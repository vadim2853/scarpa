module Spree
  module Admin
    module Calculator
      class MonthsController < Spree::Admin::ResourceController
        include LoadableForCalculator

        before_action :load_not_month_products, only: :edit
      end
    end
  end
end
