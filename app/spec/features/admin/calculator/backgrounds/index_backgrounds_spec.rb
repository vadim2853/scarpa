require 'rails_helper'

describe 'showing of backgrounds of index page' do
  stub_authorization!

  it 'should show list of calculator backgrounds' do
    create :background

    visit spree.admin_calculator_backgrounds_path

    expect(page).to have_content 'Listing backgrounds'
    expect(page).to have_content 'Test event name', count: 1
    expect(page).to have_content 'July', count: 1
    expect(page).to have_content '123', count: 1
  end
end
