class WineToursController < StoreController
  def show
    @tour = scope.friendly.find(params[:id])
  end

  def index
    @tours = scope
  end

  private

  def scope
    Spree::Product.by_taxon(CFG.taxons.wine_tour.title)
  end
end
