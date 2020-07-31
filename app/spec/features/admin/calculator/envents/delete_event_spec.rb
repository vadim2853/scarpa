require 'rails_helper'

describe 'deleting of calculator event' do
  stub_authorization!

  it 'should delete calculator event', js: true do
    calculator_event = create :event
    visit spree.admin_calculator_events_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{calculator_event.id}").click
    sleep 5

    expect(page).to have_content 'Event "Test event name" has been successfully removed!'
  end
end
