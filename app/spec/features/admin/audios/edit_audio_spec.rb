require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'editing of audio' do
  stub_authorization!

  before :each do
    @product = create :product
    @audio = create :audio, product_id: @product.id
  end

  it 'should visit audio editing page' do
    visit spree.admin_product_audios_path(@product)

    find(:css, 'a[data-action="edit"]').click
    expect(page).to have_content 'Editing Product'
  end

  it 'should update audio' do
    visit spree.edit_admin_product_audio_url(@product, @audio)

    expect(find('#audio_title').value).to eq 'Audio title'
    expect(find('#audio_description').value).to eq 'Audio description'

    fill_in 'audio[title]', with: 'Little update for title'
    fill_in 'audio[description]', with: 'Little update for description'
    click_button('Update')

    expect(page).to have_content 'Audio has been successfully updated!'
    expect(page).to have_content 'Little update for title'
    expect(page).to have_content 'Little update for description'
  end
end
