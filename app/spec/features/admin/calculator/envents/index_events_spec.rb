require 'rails_helper'

describe 'showing of events of index page' do
  stub_authorization!

  it 'should show list of calculator events' do
    create :event, red_rate: 0.111, white_rate: 0.222

    visit spree.admin_calculator_events_path

    expect(page).to have_content 'Listing events'
    expect(page).to have_content 'Test event name', count: 1
    expect(page).to have_content 'Red rate', count: 1
    expect(page).to have_content 'White rate', count: 1
    expect(page).to have_selector 'td[data-hook="red_rate"]', count: 1, text: '0.111'
    expect(page).to have_selector 'td[data-hook="white_rate"]', count: 1, text: '0.222'
  end
end
