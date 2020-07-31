module Spree
  module Admin
    OrdersController.class_eval do
      def complete
        @order.complete!
        Spree::StatusMailer.status_email(@order).deliver_later
        flash[:success] = Spree.t(:order_completed)
        redirect_to edit_admin_order_url(@order)
      rescue StateMachines::InvalidTransition => e
        flash[:error] = e.message
        redirect_to confirm_admin_order_url(@order)
      end

      def cancel
        @order.canceled_by(try_spree_current_user)
        Spree::StatusMailer.status_email(@order).deliver_later
        flash[:success] = Spree.t(:order_canceled)
        redirect_to :back
      end

      def resume
        @order.resume!
        Spree::StatusMailer.status_email(@order).deliver_later
        flash[:success] = Spree.t(:order_resumed)
        redirect_to :back
      end

      def approve
        @order.contents.approve(user: try_spree_current_user)
        Spree::StatusMailer.status_email(@order).deliver_later
        flash[:success] = Spree.t(:order_approved)
        redirect_to :back
      end
    end
  end
end
