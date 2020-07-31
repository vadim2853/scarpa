require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'ensure video with different formats' do
  stub_authorization!

  before :each do
    @product = create(
      :product,
      video_mp4: 'http://test.mp4',
      video_ogg: 'http://test.ogg',
      video_webm: 'http://test.webm'
    )

    visit spree.edit_admin_product_path(@product)
  end

  it 'should add video formats to product', js: true do
    within(:css, '.video_formats_list') do
      fill_in 'product[video_mp4]', with: 'https://test-with-uniq-link.mp4'
      fill_in 'product[video_ogg]', with: 'https://test-with-uniq-link.ogg'
      fill_in 'product[video_webm]', with: 'https://test-with-uniq-link.webm'
    end

    click_button('Update')

    expect(page).to have_content "Product \"#{@product.name}\" has been successfully updated!"
    expect(find('#product_video_mp4').value).to eq 'https://test-with-uniq-link.mp4'
    expect(find('#product_video_ogg').value).to eq 'https://test-with-uniq-link.ogg'
    expect(find('#product_video_webm').value).to eq 'https://test-with-uniq-link.webm'
  end

  it 'should remove video formats from product', js: true do
    expect(find('#product_video_mp4').value).to eq 'http://test.mp4'
    expect(find('#product_video_ogg').value).to eq 'http://test.ogg'
    expect(find('#product_video_webm').value).to eq 'http://test.webm'

    within(:css, '.video_formats_list') do
      fill_in 'product[video_mp4]', with: ''
      fill_in 'product[video_ogg]', with: ''
      fill_in 'product[video_webm]', with: ''
    end

    click_button('Update')

    expect(page).to have_content "Product \"#{@product.name}\" has been successfully updated!"
    expect(find('#product_video_mp4').value).to be_empty
    expect(find('#product_video_ogg').value).to be_empty
    expect(find('#product_video_webm').value).to be_empty
  end
end
