require 'rails_helper'
require 'support/shared_examples/admin_accessed_only_spec_helper'

feature 'Edit featured items' do
  let!(:store) { create(:store) }
  let(:admin) { create(:admin_user) }
  let(:featured_item) { create(:featured_item, :with_image_and_link, item_title: 'OldItemTitle') }
  let!(:path) { spree.edit_admin_featured_item_path(featured_item) }

  describe 'Authenticated admin' do
    it 'editing featured item' do
      sign_in_admin(admin)
      visit spree.edit_admin_featured_item_path(featured_item)

      fill_in 'Item title', with: 'EditedItemTitle'
      click_on Spree.t(:update)

      expect(page).to have_content 'EditedItemTitle'
      expect(page).to_not have_content 'OldItemTitle'
    end
  end

  describe 'In case of another user roles' do
    it_should_behave_like 'has admin accessed only'
  end
end
