class TicketsController < ApplicationController
  respond_to :pdf

  def show
    @item = Spree::LineItem.joins(:order).where(spree_orders: { payment_state: 'paid' }).find(params[:id])

    if current_spree_user.blank? || @item.order.user_id != current_spree_user.id || !current_spree_user.admin?
      flash[:error] = t('spree.sign_in_to_continue')

      redirect_to root_path
    end
  end
end
