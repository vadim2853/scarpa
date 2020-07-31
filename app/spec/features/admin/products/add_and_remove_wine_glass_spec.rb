require 'rails_helper'
require 'spree/testing_support/factories/product_factory'
require 'spree/testing_support/factories/taxon_factory'

describe 'adding and removing wine glass' do
  stub_authorization!

  it 'should add wine glass and after that - remove it', js: true do
    simple_product = create :product

    create :product, taxons: [create(:taxon, name: CFG.taxons.wine_glass.title)]

    visit spree.edit_admin_product_path(simple_product)

    expect(page).to have_content 'Available wine glasses:'
    expect(page).to have_selector('#wine_glasses_ids option', count: 1)

    click_link 'Add wine glass'

    expect(page).to have_selector('#listing_wine_glasses tbody tr', count: 1)
    expect(page).to have_css('#listing_wine_glasses tbody .delete-wine-glass-link', count: 1)

    click_link 'Delete wine glass'

    expect(page).to have_no_content('.delete-wine-glass-link')
  end
end
