class ProductsController < StoreController
  def show
    @product = Spree::Product.by_taxon(CFG.taxons.wine.title).friendly.find(params[:id])
    @product_variants_and_option_values = @product.variants_and_option_values(current_currency)
    @ages = prepare_ages(@product_variants_and_option_values)

    raise ActionController::RoutingError, 'Not Found' if params[:age].present? && !@ages.include?(params[:age])
  end

  def wines
    catalogue_and_render(Spree::Product.by_taxon(CFG.taxons.wine.children.regular.title))
  end

  def grappa_vermouth
    catalogue_and_render(Spree::Product.by_taxon(CFG.taxons.wine.children.grappa_vermouth.title))
  end

  def aged_vintages
    @catalogue = CatalogueService.process(
      ProductSerializer.many(
        Spree::Product.by_taxon(
          CFG.taxons.wine.children.aged_vintage.title
        )
      )
    )

    render :vintages
  end

  private

  def prepare_ages(data)
    ages = []
    data.each do |variant|
      year = variant.option_values.second&.name
      ages << year if year.present?
    end
    ages.uniq
  end

  def catalogue_and_render(relation)
    @catalogue = CatalogueService.process(ProductSerializer.many(relation))
    @catalogue[:isGrappaVermouth] = params[:action] == 'grappa_vermouth'

    render :index
  end
end
