require 'rails_helper'

describe 'deleting of winery' do
  stub_authorization!

  it 'should delete winery', js: true do
    winery = create :winery
    visit spree.admin_wineries_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{winery.id}").click

    expect(page).to have_content 'Winery has been successfully removed!'
  end
end
