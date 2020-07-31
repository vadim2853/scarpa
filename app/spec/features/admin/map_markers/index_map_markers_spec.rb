require 'rails_helper'

describe 'showing of map markers on index page' do
  stub_authorization!

  it 'should show list of map markers', js: true do
    5.times { create :map_marker }
    create :map_marker, status: Spree::MapMarker.statuses[:draft]

    visit spree.admin_map_markers_path

    expect(page).to have_content 'Listing map markers'
    expect(page).to have_content 'published', count: 5
    expect(page).to have_content 'draft', count: 1
    expect(page).to have_content 'Store', count: 6
    expect(page).to have_content 'Antica Casa Vinicola Scarpa S.R.L. (Via Montegrappa, 6, Nizza Monferrato AT, Italy)',
                                 count: 6
  end
end
