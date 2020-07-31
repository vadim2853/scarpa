require 'rails_helper'

describe 'editing of map marker' do
  stub_authorization!

  it 'should update map marker', js: true do
    map_marker = create :map_marker
    visit spree.edit_admin_map_marker_path(map_marker.id)

    expect(page).to have_content 'Antica Casa Vinicola Scarpa S.R.L. (Via Montegrappa, 6, Nizza Monferrato AT, Italy)'

    find('#map_marker_search_field_field').click

    expect(page).to have_selector '.select2-input'
    find('.select2-search input').set 'asdfs'

    expect(page).to have_selector '.select2-results .select2-result-selectable', count: 1
    find('.select2-results .select2-result-selectable').click

    expect(page).to have_selector "#map_marker_place_id[value='ChIJ7ZqglVTTD4gRs6En-v_x_LA']", visible: false
    expect(find('#map_marker_address', visible: false)['value']).to eq '211 E Chicago Ave #700, Chicago, IL 60611, '\
                                                                       'United States'
    expect(find('#map_marker_name', visible: false)['value']).to eq 'American Student Dental Association'

    click_button('Update')

    expect(page).to have_content 'Map marker "American Student Dental Association" has been successfully updated!'
    expect(page).to have_content 'American Student Dental Association '\
                                 '(211 E Chicago Ave #700, Chicago, IL 60611, United States)'
  end
end
