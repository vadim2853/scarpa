# This is somewhat contrary to standard REST convention since there is not
# actually a Checkout object. There's enough distinct logic specific to
# checkout which has nothing to do with updating an order that this approach
# is warranted.

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Style/CyclomaticComplexity
class CheckoutController < StoreController
  before_action :load_order, only: [:edit, :update]
  around_action :lock_order, only: [:edit, :update]
  before_action :set_state_if_present, only: [:edit, :update]
  before_action :mock_credentials_for_invoice, only: :update

  before_action :ensure_order_not_completed, only: [:edit, :update]
  before_action :ensure_checkout_allowed, only: [:edit, :update]
  before_action :ensure_valid_state, only: [:edit, :update]

  before_action :associate_user, only: [:edit, :update]
  before_action :check_authorization, only: [:edit, :update]

  before_action :setup_for_current_state, only: [:edit, :update]

  helper 'spree/orders'

  rescue_from Spree::Core::GatewayError, with: :rescue_from_spree_gateway_error

  # Updates the order and advances to the next state (when possible.)
  def update
    order_update = Spree::OrderUpdateAttributes.new(@order, update_params, request_env: request.headers.env)
    if order_update.apply
      @order.temporary_address = !params[:save_user_address]
      success = @order.state == 'confirm' ? @order.complete : @order.next

      unless success
        flash[:error] = @order.errors.full_messages.join('. ')
        redirect_to(checkout_state_path(@order.state)) && return
      end

      if @order.completed?
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to checkout_complete_path
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      flash[:error] = order_update.errors.full_messages.join('. ')
      redirect_to checkout_state_path(@order.state)
    end
  end

  def complete
    @order = spree_current_user.orders.last
    redirect_to cart_path if !@order.completed? || (@order.completed_at + 1.minute) < Time.current
  end

  private

  def mock_credentials_for_invoice
    return if @order.state != 'payment'

    id = params[:order][:payments_attributes].first[:payment_method_id]
    return if Spree::PaymentMethod.find(id).type != 'Spree::Gateway::Invoice'

    params[:payment_source] = {
      id => {
        name: Spree::Gateway::Invoice::NAME,
        number: Spree::Gateway::Invoice::CARD,
        expiry: (Time.zone.today + 1.year).strftime('%d/%Y'),
        verification_value: Spree::Gateway::Invoice::CARD,
        cc_type: Spree::Gateway::Invoice::TYPE
      }
    }
  end

  def lock_order
    Spree::OrderMutex.with_lock!(@order) { yield }
  rescue Spree::OrderMutex::LockFailed
    redirect_to cart_path
  end

  def update_params
    update_params = massaged_params[:order]
    if update_params.present?
      update_params.permit(permitted_checkout_attributes)
    else
      # We current allow update requests without any parameters in them.
      {}
    end
  end

  def massaged_params
    massaged_params = params.deep_dup

    move_payment_source_into_payments_attributes(massaged_params)
    move_existing_card_into_payments_attributes(massaged_params)
    set_payment_parameters_amount(massaged_params, @order)

    massaged_params
  end

  def ensure_valid_state
    if !skip_state_validation? && (params[:state] && !@order.has_checkout_step?(params[:state])) ||
       (!params[:state] && !@order.has_checkout_step?(@order.state))

      @order.state = 'cart'
      redirect_to checkout_state_path(@order.checkout_steps.first)
    end

    # Fix for https://github.com/spree/spree/issues/4117
    # If confirmation of payment fails, redirect back to payment screen
    if params[:state] == 'confirm' && @order.payment_required? && @order.payments.valid.empty?
      flash.keep
      redirect_to checkout_state_path('payment')
    end
  end

  # Should be overriden if you have areas of your checkout that don't match
  # up to a step within checkout_steps, such as a registration step
  def skip_state_validation?
    false
  end

  def load_order
    @order = current_order
    redirect_to(cart_path) && return unless @order
  end

  def set_state_if_present
    return if params[:state].blank?

    redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
    @order.state = params[:state]
  end

  def ensure_checkout_allowed
    redirect_to cart_path unless @order.checkout_allowed?
  end

  def ensure_order_not_completed
    redirect_to cart_path if @order.completed?
  end

  def setup_for_current_state
    method_name = :"before_#{@order.state}"
    send(method_name) if respond_to?(method_name, true)
  end

  def before_address
    # if the user has a default address, a callback takes care of setting
    # that; but if he doesn't, we need to build an empty one here
    default = { country_id: Spree::Country.default.id }
    @order.build_bill_address(default) unless @order.bill_address
    @order.build_ship_address(default) if @order.checkout_steps.include?('delivery') && !@order.ship_address
  end

  def before_delivery
    return if params[:order].present?

    packages = @order.shipments.map(&:to_package)
    @differentiator = Spree::Stock::Differentiator.new(@order, packages)
  end

  def before_payment
    if @order.checkout_steps.include? 'delivery'
      packages = @order.shipments.map(&:to_package)
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        @order.contents.remove(variant, quantity)
      end
    end

    if try_spree_current_user && try_spree_current_user.respond_to?(:payment_sources)
      @payment_sources = try_spree_current_user.payment_sources
    end
  end

  def rescue_from_spree_gateway_error(exception)
    @order.errors.add(:base, exception.message)
    flash[:error] = exception.message
    redirect_to checkout_state_path(@order.state)
  end

  def check_authorization
    authorize!(:edit, current_order, cookies.signed[:guest_token])
  end
end
