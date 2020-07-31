require 'rails_helper'
require 'support/shared_examples/admin_accessed_only_spec_helper'

feature 'Create featured items' do
  let!(:store) { create(:store) }
  let(:admin) { create(:admin_user) }
  let!(:path) { spree.new_admin_featured_item_path }

  describe 'Authenticated admin' do
    it 'try to create featured item' do
      sign_in_admin(admin)
      visit spree.new_admin_featured_item_path

      fill_in Spree.t('admin.featured_item.item_title'), with: 'TestItemTitle'
      fill_in Spree.t('admin.featured_item.link_url'), with: '/example/link_url'
      fill_in Spree.t('admin.video_mp4'), with: 'http://d18izmg1gcfkjo.cloudfront.net/hmbia.com/HMB.mp4'
      attach_file('featured_item[image]', File.absolute_path("#{Rails.root}/spec/fixtures/images/slide.jpg"))
      click_on 'Create'

      expect(page).to have_content Spree.t(:successfully_created, resource: Spree.t('admin.featured_item.self_name'))
      expect(page).to have_content 'TestItemTitle'

      click_on 'Edit'
      expect(page).to have_selector "input[value='http://d18izmg1gcfkjo.cloudfront.net/hmbia.com/HMB.mp4']"
    end
  end

  describe 'In case of another user roles' do
    it_should_behave_like 'has admin accessed only'
  end
end
