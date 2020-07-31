require 'spree/core/controller_helpers/order.rb'
require 'spree/core/controller_helpers/pricing.rb'

class StoreController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::Pricing
  include Spree::Core::ControllerHelpers::Order

  layout 'application'

  skip_before_action :set_current_order, only: :cart_link

  def cart_link
    render partial: 'link_to_cart'
    fresh_when(simple_current_order)
  end
end
