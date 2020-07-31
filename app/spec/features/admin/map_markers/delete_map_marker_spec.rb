require 'rails_helper'

describe 'deleting of map marker' do
  stub_authorization!

  it 'should delete map marker', js: true do
    map_marker = create :map_marker
    visit spree.admin_map_markers_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{map_marker.id}").click

    expect(page).to have_content 'Map marker "Antica Casa Vinicola Scarpa S.R.L." has been successfully removed!'
  end
end
