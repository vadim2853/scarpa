require 'rails_helper'
require 'spree/testing_support/factories/product_factory'
require 'spree/testing_support/factories/image_factory'
require 'spree/testing_support/factories/variant_factory'

describe 'checking perfect match flag' do
  stub_authorization!

  before :each do
    @product = create :product
    @variant = create :variant, product: @product, sku: 'qwerty-123'
    @images = []
    2.times { @images << create(:image, viewable_id: @variant.id, viewable_type: 'Spree::Variant') }

    visit spree.admin_product_images_path(@product)
  end

  it 'should find two images on the page' do
    expect(page).to have_css '.perfect_match_flag', count: 2
  end

  it 'should find every image with is_perfect_match flag equal to false' do
    expect(all('.perfect_match_flag').map(&:text)).to eq %w(false false)
  end

  specify 'what every image related to just one product variant' do
    variants = []
    2.times { variants << "#{@variant.sku} Size: S" }
    expect(all('.image_variant').map(&:text)).to eq variants
  end

  specify 'what just one image can be with is_perfect_match flag equal to true' do
    find("#spree_image_#{@images.first.id} a[data-action='edit']").click
    check 'image[is_perfect_match]'
    click_button 'Update'

    check_perfect_match_flags_after_refresh %w(false true)

    find("#spree_image_#{@images.second.id} a[data-action='edit']").click
    check 'image[is_perfect_match]'
    click_button 'Update'

    check_perfect_match_flags_after_refresh %w(false true)
  end

  def check_perfect_match_flags_after_refresh(expectation)
    expect(page).to have_content 'Image has been successfully updated!'
    expect(all('.perfect_match_flag').map(&:text).sort).to eq expectation
  end
end
