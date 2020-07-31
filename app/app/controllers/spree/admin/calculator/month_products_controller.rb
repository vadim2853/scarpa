module Spree
  module Admin
    module Calculator
      class MonthProductsController < ApplicationController
        include LoadableForCalculator

        before_action :load_month

        def create
          @month_product = Spree::Calculator::MonthProduct.new(calculator_month_id: month_id, product_id: product_id)
          if @month_product.save
            @new_month_product = Spree::Product.find(product_id)
            load_not_month_products
          end

          respond_to { |format| format.js }
        end

        def destroy
          Spree::Calculator::MonthProduct.delete_relations(month_id, product_id)
          @deleted_month_product_id = product_id

          load_not_month_products
          respond_to { |format| format.js }
        end

        private

        def load_month
          @month = Spree::Calculator::Month.find(month_id)
        end

        def product_id
          params.require(:product_id)
        end

        def month_id
          params.require(:id)
        end
      end
    end
  end
end
