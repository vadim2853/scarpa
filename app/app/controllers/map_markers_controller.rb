class MapMarkersController < StoreController
  def index
    render json: Spree::MapMarker.places_within_polygon(params.require(:polygon), params[:filter])
  end

  def show
    marker = Spree::MapMarker.find params.require(:id)

    if marker.google?
      render json: Spree::MapMarker.place_details(marker)
    else
      render json: marker.as_json_details
    end
  end

  def nearest
    render json: Spree::MapMarker.nearest(params.require(:lat), params.require(:lng), params[:filter])
  end

  def address_autocomplete
    render json: Spree::MapMarker.address(params[:query])
  end
end
