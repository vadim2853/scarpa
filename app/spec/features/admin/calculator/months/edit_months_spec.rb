require 'rails_helper'
require 'spree/testing_support/factories/taxon_factory'

describe 'editing of calculator month' do
  stub_authorization!

  Given!(:months) { (1..12).map { |m| create(:month, name: Date::MONTHNAMES[m], rate: 1) } }
  When { visit spree.edit_admin_calculator_month_path(months[5]) }

  context 'all elements present' do
    Then { expect(page).to have_css('h5', text: 'Month: June') }
    And  { expect(page).to have_css('#calculator_month_rate[value="1.0"]') }
    And  { expect(page).to have_css('div[data-hook="admin_product_form_related_products"]') }
  end

  context 'edit month' do
    When { fill_in 'calculator_month[rate]', with: '8.5' }
    When { click_button('Update') }

    Then { expect(page).to have_content 'Month "June" has been successfully updated!' }
    And  { expect(page).to have_content('8.5') }
  end

  context 'add related product', js: true do
    Given(:wine_taxon) { create :taxon, name: CFG.taxons.wine.title }

    Given!(:product) { create :product, available_on: '30.07.2016', tax_category_id: nil, taxons: [wine_taxon] }

    When { select2_single(nil, product.name) }
    When { find('a.add-month-product-link').click }
    Then { expect(find('#listing_month_products')).to have_content(product.name) }

    context 'click updae button' do
      When { click_button('Update') }
      Then { expect(page).to have_content 'Month "June" has been successfully updated!' }
    end
  end
end
