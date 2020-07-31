require 'rails_helper'
require 'spree/testing_support/factories/product_factory'
require 'spree/testing_support/factories/taxon_factory'

describe 'adding and removing related product', js: true do
  stub_authorization!

  let(:taxon) { create :taxon, name: CFG.taxons.wine.title }
  let(:product) { create(:product) }

  before { 2.times { create(:product, taxons: [taxon]) } }
  before { visit spree.edit_admin_product_path(product) }

  describe 'there are products for relation' do
    it { expect(page).to have_content('Available for relation') }
    it { expect(page).to have_css('#related_ids option', count: 2) }
  end

  context '"Add relation" is clicked' do
    before { click_link 'Add relation' }

    it 'relation is added' do
      expect(page).to have_css('#listing_products tbody tr', count: 1)
      expect(page).to have_css('#listing_products tbody .delete-related-product-link', count: 1)
    end

    context '"Delete relation" is clicked' do
      before { click_link 'Delete relation' }

      it { expect(page).not_to have_content('.delete-related-product-link') }
    end
  end
end
