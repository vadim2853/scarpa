# rubocop:disable all
module Spree
  Order.class_eval do
    def use_billing?
      use_billing.in?([true, 'true', '1', 'on'])
    end

    def items_by_taxon(name)
      line_items.joins(variant: [product: [:taxons]]).where(spree_taxons: { name: name })
    end

    def add_store_credit_payments
      payments.store_credits.checkout.each(&:invalidate!)

      # this can happen when multiple payments are present, auto_capture is
      # turned off, and one of the payments fails when the user tries to
      # complete the order, which sends the order back to the 'payment' state.
      authorized_total = payments.pending.sum(:amount)

      remaining_total = outstanding_balance - authorized_total

      if user && user.store_credits.any?
        payment_method = Spree::PaymentMethod::StoreCredit.first

        user.store_credits.order_by_priority.each do |credit|
          break if remaining_total.zero?
          next if credit.amount_remaining.zero?

          amount_to_take = [credit.amount_remaining, remaining_total].min
          payments.create!(source: credit,
                           payment_method: payment_method,
                           amount: amount_to_take,
                           state: 'checkout',
                           response_code: credit.generate_authorization_code)
          remaining_total -= amount_to_take
        end
      end

      other_payments = payments.checkout.not_store_credits
      if remaining_total.zero?
        other_payments.each(&:invalidate!)
      elsif other_payments.size == 1
        other_payments.first.update_attributes!(amount: remaining_total)
      end

      payments.reset
    end

    def covered_by_valid_payments?
      payments.where(state: %w(checkout completed pending processing)).sum(:amount) >= total
    end
  end
end
