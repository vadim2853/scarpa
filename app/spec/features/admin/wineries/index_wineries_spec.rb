require 'rails_helper'

describe 'showing of wineries of index page' do
  stub_authorization!

  it 'should show list of wineries', js: true do
    5.times { create :winery }
    create :winery, status: Spree::Winery.statuses[:draft]

    visit spree.admin_wineries_path

    expect(page).to have_content 'Listing wineries'
    expect(page).to have_content 'published', count: 5
    expect(page).to have_content 'draft', count: 1
    expect(page).to have_content 'Test title', count: 6
    expect(page).to have_content 'description content', count: 6
  end
end
