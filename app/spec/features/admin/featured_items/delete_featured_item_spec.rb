require 'rails_helper'

feature 'Delete featured items' do
  let!(:store) { create(:store) }
  let(:admin) { create(:admin_user) }
  let!(:featured_item) { create(:featured_item, :with_image_and_link, item_title: 'ItemTitle') }

  describe 'Authenticated admin' do
    it 'deleting featured item', js: true do
      sign_in_admin(admin)
      visit spree.admin_featured_items_path

      expect(page).to have_content 'ItemTitle'
      page.evaluate_script('window.confirm = function() { return true; }')
      find("#del_#{featured_item.id}").click

      expect(page).to_not have_content 'ItemTitle'
      expect(page).to have_content Spree.t(:successfully_removed, resource: Spree.t('admin.featured_item.self_name'))
    end
  end
end
