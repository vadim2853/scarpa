class OrdersController < StoreController
  include Spree::Core::ControllerHelpers::StrongParameters

  before_action :ensure_orders
  before_action :assign_order, only: :update

  respond_to :html

  # note: do not lock the #edit action because that's where we redirect when we fail to acquire a lock
  around_action :lock_order, only: :update
  skip_before_action :verify_authenticity_token, only: :populate

  def show
    @order = Spree::Order.find_by_number!(params[:id])
    redirect_to cabinet_path if @order.user != spree_current_user
  end

  def edit
    @order = current_order || Spree::Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
    associate_user
  end

  def update
    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.key?(:checkout)
            @order.next if @order.cart?
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    data = params.require(:order)
    product = Spree::Product.find_by_variant(data[:variant_id])
    errors = OrderPopulationValidator.validate(product, data)

    return render(text: errors.join(', ')) if errors.any?

    begin
      current_order(create_order_if_necessary: true)
        .contents
        .add(
          variant_for_tour(product.variants, data[:variant_id], data[:date_time]),
          data[:quantity].to_i
        )
    rescue ActiveRecord::RecordInvalid => e
      error = e.record.errors.full_messages.join(', ')
    end

    error.blank? ? cart_link : render(text: error)
  end

  def ensure_orders
    cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
    order = Spree::Order.find_by_number(params[:id]) || current_order

    if order.present?
      authorize! :edit, order, cookies.signed[:guest_token]
    else
      authorize! :create, Spree::Order
    end
  end

  private

  def order_params
    if params[:order].present?
      params[:order].permit(*permitted_order_attributes)
    else
      {}
    end
  end

  def assign_order
    order = current_order

    if order.present?
      @order = order
    else
      redirect_to(root_path) && return
    end
  end

  def lock_order
    Spree::OrderMutex.with_lock!(@order) { yield }
  rescue Spree::OrderMutex::LockFailed => e
    render text: e.message, status: 409
  end

  def variant_for_tour(variants, variant_id, date_time)
    orig_variant = Spree::Variant.find(variant_id)

    return orig_variant if date_time.blank?

    option_type = Spree::OptionType.find_by(name: CFG.tours.options.time)
    value = option_type.option_values.find_or_create_by(name: date_time, presentation: date_time) do |v|
      v.position = option_type.option_values.count.next
    end

    variant = variants
              .joins(:option_values_variants)
              .find_by(
                presentation: orig_variant.presentation,
                spree_option_values_variants: { option_value_id: value.id }
              )

    return variant if variant

    variant = orig_variant.dup
    variant.price = orig_variant.price.dup
    variant.hidden = true
    variant.option_value_ids = orig_variant.option_value_ids + [value.id]

    variant.save

    variant
  end
end
