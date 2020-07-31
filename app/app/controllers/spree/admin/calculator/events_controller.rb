module Spree
  module Admin
    module Calculator
      class EventsController < Spree::Admin::ResourceController
        include LoadableForCalculator

        before_action :load_not_event_products, only: :edit
      end
    end
  end
end
