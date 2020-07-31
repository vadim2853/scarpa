module CabinetHelper
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def order_status_tag(order)
    tag = case
          when order.cart?
            "<div class='order_hist__status_color yellow'>#{Spree.t('checkout_statuses.cart')}</div>"
          when order.address?
            "<div class='order_hist__status_color yellow'>#{Spree.t('checkout_statuses.address')}</div>"
          when order.delivery?
            "<div class='order_hist__status_color yellow'>#{Spree.t('checkout_statuses.delivery')}</div>"
          when order.payment?
            "<div class='order_hist__status_color yellow'>#{Spree.t('checkout_statuses.payment')}</div>"
          when order.confirm?
            "<div class='order_hist__status_color yellow'>#{Spree.t('checkout_statuses.confirmed')}</div>"
          when order.complete?
            "<div class='order_hist__status_color green'>#{Spree.t('checkout_statuses.completed')}</div>"
          when order.canceled?
            "<div class='order_hist__status_color red'>#{Spree.t('checkout_statuses.canceled')}</div>"
          when order.awaiting_return?
            "<div class='order_hist__status_color yellow'#{Spree.t('checkout_statuses.awaiting_return')}/div>"
          when order.returned?
            "<div class='order_hist__status_color green'>#{Spree.t('checkout_statuses.returned')}</div>"
          when order.resumed?
            "<div class='order_hist__status_color green'>#{Spree.t('checkout_statuses.resumed')}</div>"
          else
            "<div class='order_hist__status_color red'>#{Spree.t('checkout_statuses.undefined')}</div>"
          end
    tag.html_safe
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def link_to_tracking_service(shipment, options = {})
    return unless shipment.tracking && shipment.shipping_method

    if shipment.tracking_url
      link_to(shipment.tracking, shipment.tracking_url, options.merge(target: '_blank'))
    else
      content_tag(:span, shipment.tracking)
    end
  end
end
