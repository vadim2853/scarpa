module Spree
  module Admin
    module Calculator
      class BackgroundsController < Spree::Admin::ResourceController
        include LoadableForCalculator
      end
    end
  end
end
