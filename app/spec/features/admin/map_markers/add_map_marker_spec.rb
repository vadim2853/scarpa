require 'rails_helper'

describe 'creating new map marker' do
  stub_authorization!

  specify 'creating of new map marker', js: true do
    visit spree.new_admin_map_marker_path

    expect(page).to have_selector '#map_marker_search_field_field'
    find('#map_marker_search_field_field').click

    expect(page).to have_selector '.select2-input'
    find('.select2-search input').set 'ANTICA CASA VINICOLA SCARPA'

    expect(page).to have_selector '.select2-results .select2-result-selectable', count: 1
    find('.select2-results .select2-result-selectable').click

    expect(page).to have_selector "#map_marker_place_id[value='ChIJJfWwQuCFh0cRZmuFgG-z-Sg']", visible: false
    expect(page).to have_selector "#map_marker_lat[value='44.7712037']", visible: false
    expect(page).to have_selector "#map_marker_lng[value='8.350949']", visible: false
    expect(find('#map_marker_address', visible: false)['value']).to eq 'Via Montegrappa, 6, Nizza Monferrato AT, Italy'
    expect(find('#map_marker_name', visible: false)['value']).to eq 'Antica Casa Vinicola Scarpa S.R.L.'

    choose('map_marker_status_published')
    choose('map_marker_marker_type_m_office')

    click_button('Create')

    expect(page).to have_content 'Listing map markers'
    expect(page).to have_content 'Map marker "Antica Casa Vinicola Scarpa S.R.L." has been successfully created!'
    expect(page).to have_content 'published'
    expect(page).to have_content 'Antica Casa Vinicola Scarpa S.R.L. (Via Montegrappa, 6, Nizza Monferrato AT, Italy)'
  end
end
