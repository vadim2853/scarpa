module Ui
  class LeftoverLoadingInteraction < ::BaseInteraction
    include WineToursHelper

    def init
      @tour = Spree::Product.friendly.find(params[:wine_tour_id])
    end

    def as_json(*)
      { count: tickets_left(@tour, params[:id]) }
    end
  end
end
