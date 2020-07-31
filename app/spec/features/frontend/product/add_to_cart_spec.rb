require 'rails_helper'
require 'spree/testing_support/factories/option_type_factory'
require 'spree/testing_support/factories/option_value_factory'
require 'spree/testing_support/factories/variant_factory'
require 'spree/testing_support/factories/taxon_factory'

describe 'ensure adding product to cart', js: true do
  let(:params) { { name: 'Product of Scarpa' } }
  let(:product) { create :product, params.merge(taxons: [wine_taxon]) }
  let(:wine_taxon) { create :taxon, name: CFG.taxons.wine.title }

  let(:bottle) { create :option_type, name: 'bottle' }
  let(:small_bottle) { create :option_value, name: '0.75L', presentation: '0.75L', option_type: bottle, position: 2 }

  before do
    params.merge(option_types: [bottle])
    create :variant, product: product, option_values: [small_bottle], cost_price: '27'

    visit_as_adult product_path(product)
  end

  it 'should add product to cart' do
    find('.btn.red.add_to_cart').click

    expect(page).to have_selector '.header_location .header_amount', text: '1'
  end
end
