module Spree
  OrderUpdateAttributes.class_eval do
    attr_accessor :errors

    # Assign the attributes to the order and save the order
    # @return true if saved, otherwise false and errors will be set on the order
    def apply
      assign_order_attributes
      assign_payments_attributes

      if order.save
        order.set_shipments_cost if order.shipments.any?
        true
      else
        @errors = order.errors
        false
      end
    end
  end
end
