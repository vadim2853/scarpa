module Spree
  module Admin
    class MapMarkersController < Spree::Admin::ResourceController
      def autocomplete
        render json: Spree::MapMarker.autocomplete(params[:query])
      end
    end
  end
end
