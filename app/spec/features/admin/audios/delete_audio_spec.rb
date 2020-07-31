require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'deleting of the audio' do
  stub_authorization!

  it 'should delete audio', js: true do
    product = create :product
    create :audio, product_id: product.id
    visit spree.admin_product_audios_path(product)

    page.evaluate_script('window.confirm = function() { return true; }')
    find('.delete-resource').click

    expect(page).to have_content 'Audio has been successfully removed!'
    expect(page).to have_no_content('.audios_table tbody')
  end
end
