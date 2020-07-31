require 'rails_helper'

describe 'showing of months of index page' do
  stub_authorization!
  Given!(:month_june) { create :month, name: 'June', rate: 2 }
  Given!(:month_may) { create :month, name: 'May' }
  Given(:june_path) { spree.edit_admin_calculator_month_path(month_june) }
  Given(:may_path) { spree.edit_admin_calculator_month_path(month_may) }

  When { visit spree.admin_calculator_months_path }

  Then { expect(page).to have_content 'Listing months' }
  And  { expect(page.find('tr[data-hook="months_row_1"]')).to have_content('June 2') }
  And  { expect(page.find('tr[data-hook="months_row_1"] a')[:href]).to eq(june_path) }
  And  { expect(page.find('tr[data-hook="months_row_2"]')).to have_content('May 1') }
  And  { expect(page.find('tr[data-hook="months_row_2"] a')[:href]).to eq(may_path) }
end
