require 'rails_helper'
require 'spree/testing_support/factories/option_type_factory'
require 'spree/testing_support/factories/option_value_factory'
require 'spree/testing_support/factories/variant_factory'
require 'spree/testing_support/factories/taxon_factory'

describe 'ensure product checkout', js: true do
  let(:blogger) { create :blog_user }
  let(:params) { { name: 'Product of Scarpa' } }
  let(:product) { create :product, params.merge(taxons: [wine_taxon]) }
  let(:wine_taxon) { create :taxon, name: CFG.taxons.wine.title }

  let(:bottle) { create :option_type, name: 'bottle' }
  let(:small_bottle) { create :option_value, name: '0.75L', presentation: '0.75L', option_type: bottle, position: 2 }

  before do
    create :country, iso: 'IT'

    params.merge(option_types: [bottle])
    create :variant, product: product, option_values: [small_bottle], cost_price: '27'

    login_as(blogger)
    visit_as_adult product_path(product)
  end

  specify 'product buying' do
    find('.btn.red.add_to_cart').click
    expect(page).to have_selector '.header_location .header_amount', text: '1'

    find('.header_location .header_amount').click
    expect(page).to have_content 'SHOPPING CART'

    click_button('Checkout')
    expect(page).to have_content 'DELIVERING ADDRESSES'
  end
end
