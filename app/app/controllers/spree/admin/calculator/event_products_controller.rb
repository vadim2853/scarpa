module Spree
  module Admin
    module Calculator
      class EventProductsController < ApplicationController
        include LoadableForCalculator

        before_action :load_event

        def create
          @event_product = Spree::Calculator::EventProduct.new(calculator_event_id: event_id, product_id: product_id)
          if @event_product.save
            @new_event_product = Spree::Product.find(product_id)
            load_not_event_products
          end

          respond_to { |format| format.js }
        end

        def destroy
          Spree::Calculator::EventProduct.delete_relations(event_id, product_id)
          @deleted_event_product_id = product_id

          load_not_event_products
          respond_to { |format| format.js }
        end

        private

        def load_event
          @event = Spree::Calculator::Event.find(event_id)
        end

        def product_id
          params.require(:product_id)
        end

        def event_id
          params.require(:id)
        end
      end
    end
  end
end
