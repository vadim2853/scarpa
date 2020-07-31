module Spree
  module Admin
    class FeaturedItemsController < Spree::Admin::ResourceController
      def index
        @featured_items = FeaturedItem.order(:position)
      end
    end
  end
end
