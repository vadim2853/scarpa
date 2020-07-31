module Spree
  module Admin
    class RelatedProductsController < ApplicationController
      include LoadableForProducts

      before_action :load_product

      def create
        @related_product = ProductRelation.new(related_id: product_id, inverse_related_id: related_id)
        if @related_product.save
          @new_related_product = Spree::Product.find(related_id)
          load_not_related_products
        end
        respond_to { |format| format.js }
      end

      def destroy
        ProductRelation.delete_relations(product_id, related_id)
        @deleted_related_product_id = related_id

        load_not_related_products
        respond_to { |format| format.js }
      end

      private

      def load_product
        @product = Spree::Product.find(product_id)
      end

      def related_id
        params.require(:related_id)
      end

      def product_id
        params.require(:id)
      end
    end
  end
end
