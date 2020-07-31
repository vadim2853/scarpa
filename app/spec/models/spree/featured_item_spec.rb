require 'rails_helper'
require 'spree/testing_support/factories/product_factory'
require 'spree/testing_support/factories/image_factory'

RSpec.describe Spree::FeaturedItem, type: :model do
  let(:product) { create(:product) }
  let!(:image) { create(:image, viewable_id: product.id, viewable_type: 'Spree::Variant') }
  let(:featured_item_with_product) { build(:featured_item, spree_product: product) }
  let(:featured_item_with_link_and_image) { build(:featured_item, :with_image_and_link) }

  let(:featured_item_with_image) do
    build(:featured_item,
          image_file_name: 'test.jpg',
          image_content_type: 'image/jpg',
          image_file_size: 1024)
  end

  let(:featured_item_with_link) { build(:featured_item, link_url: 'test/link_url') }
  let(:empty_featured_item) { build(:featured_item) }
  let(:featured_item_with_product_and_image) { create(:featured_item, spree_product: product) }

  it { should define_enum_for(:display_mode).with [:link_to_product, :external_link, :video] }
  it { should validate_presence_of :item_title }
  it { should validate_presence_of :position }
  it { should define_enum_for(:item_size).with [:small, :middle, :big] }
  it { should have_attached_file(:image) }
  it { should validate_attachment_content_type(:image).allowing('image/jpeg', 'image/png', 'image/jpg') }

  describe 'mark as valid, featured item' do
    it 'with product' do
      expect(featured_item_with_product.valid?).to eq true
    end
    it 'link and image' do
      expect(featured_item_with_link_and_image.valid?).to eq true
    end
  end
  describe 'return image_url from product' do
    it 'if it attached' do
      expect(featured_item_with_product_and_image.image_url).to eq image.attachment.url
    end
  end
  describe 'return image_url from featured_item ' do
    it 'if product not attached' do
      expect(featured_item_with_link_and_image.image_url).to eq featured_item_with_link_and_image.image.url
    end
  end
end
