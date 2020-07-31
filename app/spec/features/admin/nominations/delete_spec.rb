require 'rails_helper'

describe 'deleting of nomination' do
  stub_authorization!

  it 'should delete nomination', js: true do
    nomination = create :nomination
    visit spree.admin_nominations_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{nomination.id}").click

    expect(page).to have_content 'Nomination has been successfully removed!'
  end
end
