module LoadableForProducts
  extend ActiveSupport::Concern

  private

  def load_not_related_products
    @not_related_products = @product.not_related_products
  end

  def load_wine_glasses
    @wine_glasses = Spree::Product.by_taxon(CFG.taxons.wine_glass.title)
  end
end
