require 'rails_helper'

describe 'adding new property', js: true do
  stub_authorization!

  before :each do
    visit spree.admin_properties_path

    find('a[data-update="new_property_container"]').click
  end

  it 'should add new property with required group' do
    expect(find('#property_group_field span.required')).to have_content '*'
    expect(page).to have_selector '#property_group'

    within(:css, '#new_property') do
      fill_in 'property[name]', with: 'test property'
      fill_in 'property[presentation]', with: 'test property presentation'

      execute_script("$('#property_group').val('wine_aeration').trigger('change');")
      expect(find('.select2-chosen')).to have_content Spree.t(:wine_aeration)

      click_button 'Create'
    end

    expect(page).to have_content 'Property "test property" has been successfully created!'

    within(:css, '#listing_properties') do
      expect(page).to have_content 'test property'
      expect(page).to have_content 'test property presentation'
      expect(page).to have_content Spree.t(:wine_aeration)
    end
  end
end
