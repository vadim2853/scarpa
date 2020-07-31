require 'rails_helper'
require 'support/shared_examples/admin_accessed_only_spec_helper'

feature 'Index featured items' do
  let!(:store) { create(:store) }
  let(:admin) { create(:admin_user) }
  let!(:featured_item) { create(:featured_item, :with_image_and_link, item_title: 'ItemTitle') }
  let!(:path) { spree.admin_featured_items_path }

  describe 'Authenticated admin' do
    it 'looks at featured items on index page' do
      sign_in_admin(admin)
      visit spree.admin_featured_items_path

      expect(page).to have_content 'ItemTitle'
      expect(page).to have_link Spree.t('admin.featured_item.new_link_button')
      expect(page).to have_link Spree.t('admin.featured_item.edit_link')
      expect(page).to have_link Spree.t('admin.featured_item.destroy_link')
    end
  end

  describe 'In case of another user roles' do
    it_should_behave_like 'has admin accessed only'
  end
end
