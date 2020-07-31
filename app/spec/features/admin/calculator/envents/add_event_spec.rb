require 'rails_helper'

describe 'creating new calculator event' do
  stub_authorization!

  it 'should create new calculator event' do
    visit spree.new_admin_calculator_event_path

    fill_in 'calculator_event[name]', with: 'Test record'
    fill_in 'calculator_event[red_rate]', with: '0.45'
    fill_in 'calculator_event[white_rate]', with: '0.66'

    click_button('Create')

    expect(page).to have_content 'Listing events'
    expect(page).to have_content 'Event "Test record" has been successfully created!'
    expect(page).to have_content '0.45'
    expect(page).to have_content '0.66'
  end
end
