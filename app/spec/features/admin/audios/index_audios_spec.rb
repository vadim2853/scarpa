require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'ensure audios index' do
  stub_authorization!

  before(:each) { @product = create :product }

  describe 'elements on the page' do
    before(:each) { visit spree.admin_product_audios_path(@product) }

    it 'should find editing product title' do
      expect(find('.page-title')).to have_content @product.name
    end

    it 'should find audios link in sidebar menu' do
      within(:css, '#sidebar') do
        expect(find('.active').find('a span')).to have_content 'Audios'
      end
    end
  end

  it 'should find audio item on this page', js: true do
    create :audio, product_id: @product.id
    visit spree.admin_product_audios_path(@product)

    within(:css, '.audios_table') do
      expect(page).to have_content 'Audio title'
      expect(page).to have_content 'Audio description'
    end
  end
end
