require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'ensure topics index' do
  stub_authorization!

  before(:each) { @product = create :product }

  describe 'elements on the page' do
    before(:each) { visit spree.admin_product_topics_path(@product) }

    it 'should find editing product title' do
      expect(find('.page-title')).to have_content @product.name
    end

    it 'should find topics link in sidebar menu' do
      expect(find('#sidebar .active').find('a span')).to have_content 'Topics'
    end
  end

  it 'should find topic item on this page', js: true do
    topic = create :topic, product_id: @product.id
    visit spree.admin_product_topics_path(@product)

    within(:css, '.topics_table') do
      expect(page).to have_content 'Topic title'
      expect(find('tbody img')[:src].include?(topic.image.url(:icon))).to be_truthy
      expect(page).to have_content 'http://google.com'
    end
  end
end
