module Spree
  module Admin
    class ProductDescriptionsController < Spree::Admin::ResourceController
      belongs_to 'spree/product', find_by: :slug

      private

      def location_after_destroy
        admin_product_product_descriptions_url(@product)
      end

      def location_after_save
        admin_product_product_descriptions_url(@product)
      end
    end
  end
end
