module Spree
  module Admin
    class WineGlassesController < ApplicationController
      include LoadableForProducts

      before_action :load_product

      respond_to :js

      def create
        @product.update_attribute(:wine_glass_id, wine_glass_id)
        @new_wine_glass = Spree::Product.find(wine_glass_id) if @product.persisted?
      end

      def destroy
        @product.update_attribute(:wine_glass_id, nil)
        @deleted_wine_glass_id = wine_glass_id

        load_wine_glasses
      end

      private

      def load_product
        @product = Spree::Product.find(params.require(:id))
      end

      def wine_glass_id
        params.require(:wine_glass_id)
      end
    end
  end
end
