module Spree
  module Admin
    class TopicsController < Spree::Admin::ResourceController
      belongs_to 'spree/product', find_by: :slug

      private

      def location_after_destroy
        admin_product_topics_url(@product)
      end

      def location_after_save
        admin_product_topics_url(@product)
      end
    end
  end
end
