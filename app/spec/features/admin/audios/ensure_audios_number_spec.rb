require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'ensure audios number not more than 2' do
  stub_authorization!

  before :each do
    @product = create :product
    2.times { create :audio, product_id: @product.id }
  end

  it 'should not find "+New Audion" on index page' do
    visit spree.admin_product_audios_path(@product)

    expect(find('#content-header')).to have_no_content 'New audio'
  end

  it 'user should not get access to audio creating page' do
    visit spree.new_admin_product_audio_url(@product)

    expect(page).to have_content 'You can add just 2 audios to product!'
  end
end
