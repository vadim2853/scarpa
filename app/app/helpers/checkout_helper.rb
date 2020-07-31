module CheckoutHelper
  def build_ship_address_with_default_country(order)
    object = order.build_ship_address
    object.country_id = Spree::Country.find_by(iso: 'IT').id
    object
  end

  def shipping_rates(rates)
    rates.map do |rate|
      [
        "#{rate.name} - #{rate.display_cost}",
        { 'data-rate-cost' => rate.cost },
        rate.id
      ]
    end
  end

  def available_payment_methods(order)
    order.available_payment_methods.map do |m|
      [m.name, { 'data-disable-submit' => m.name.downcase.include?('paypal') }, m.id]
    end
  end

  def checkout_states
    @order.checkout_steps
  end

  # rubocop:disable Metrics/AbcSize
  def checkout_progress
    states = checkout_states
    items = states.map do |state|
      text = Spree.t("order_state.#{state}").titleize

      css_classes = []
      current_index = states.index(@order.state)
      state_index = states.index(state)

      if state_index < current_index
        css_classes << 'prev'
        link = link_to(content_tag('span', text), checkout_state_path(state))
      else
        link = link_to(content_tag('span', text), 'javascript:;')
      end

      css_classes << 'next' if state_index == current_index + 1
      css_classes << 'current' if state == @order.state
      content_tag('li', link, class: css_classes.join('-'))
    end
    content_tag('ul', raw(items.join("\n")), class: 'progress-steps', id: "checkout-step-#{@order.state}")
  end
  # rubocop:enable Metrics/AbcSize
end
