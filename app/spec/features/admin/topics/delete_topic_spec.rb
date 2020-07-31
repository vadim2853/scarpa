require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'deleting of the topic' do
  stub_authorization!

  it 'should delete topic', js: true do
    product = create :product
    create :topic, product_id: product.id
    visit spree.admin_product_topics_path(product)

    page.evaluate_script('window.confirm = function() { return true; }')
    find('.delete-resource').click

    expect(page).to have_content 'Topic has been successfully removed!'
    expect(page).to have_no_content('.topics_table tbody')
  end
end
