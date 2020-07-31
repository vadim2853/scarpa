require 'rails_helper'

describe 'showing of slides of index page' do
  stub_authorization!

  it 'should show list of slides', js: true do
    5.times { create :slide }
    create :slide, status: Spree::Slide.statuses[:draft]

    visit spree.admin_slides_path

    expect(page).to have_content 'Listing slides'
    expect(page).to have_content 'published', count: 5
    expect(page).to have_content 'draft', count: 1
    expect(page).to have_content 'Test title', count: 6
    expect(page).to have_content 'description content', count: 6
  end
end
