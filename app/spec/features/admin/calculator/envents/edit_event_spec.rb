require 'rails_helper'

describe 'editing of calculator event' do
  stub_authorization!

  it 'should update calculator event' do
    calculator_event = create :event, name: 'Super things', red_rate: 0.111, white_rate: 0.222
    visit spree.edit_admin_calculator_event_path(calculator_event.id)

    expect(find('#calculator_event_name').value).to eq 'Super things'
    expect(find('#calculator_event_red_rate').value).to eq '0.111'
    expect(find('#calculator_event_white_rate').value).to eq '0.222'

    fill_in 'calculator_event[name]', with: 'Little update for name'
    fill_in 'calculator_event[red_rate]', with: '0.45'
    fill_in 'calculator_event[white_rate]', with: '0.66'
    click_button('Update')

    expect(page).to have_content 'Event "Little update for name" has been successfully updated!'
    expect(page).to have_content '0.45'
    expect(page).to have_content '0.66'
  end
end
