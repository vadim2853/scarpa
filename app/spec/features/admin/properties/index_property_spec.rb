require 'rails_helper'

describe 'index of properties', js: true do
  stub_authorization!

  before :each do
    create :property, group: 'wine_profile'

    visit spree.admin_properties_path
  end

  describe 'ensuring of property group' do
    it 'ensure presence of group header cell in table' do
      expect(page).to have_content 'GROUP', count: 1
    end

    it 'should find property with "Wine profile" group' do
      expect(page).to have_content 'Wine profile', count: 1
    end
  end
end
