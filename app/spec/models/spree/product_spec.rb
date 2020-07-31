require 'rails_helper'
require 'spree/testing_support/factories/taxon_factory'
require 'spree/testing_support/factories/product_factory'

describe Spree::Product do
  describe 'relations' do
    it { should belong_to(:wine_glass) }
  end

  describe 'methods' do
    describe '#not_related_products' do
      let(:taxon) { create :taxon, name: CFG.taxons.wine.title }
      let(:product) { create :product, taxons: [taxon] }
      let(:related_product) { create :product, taxons: [taxon] }

      let!(:other_product) { create :product, taxons: [taxon] }

      before { ProductRelation.create(related_id: product.id, inverse_related_id: related_product.id) }

      it { expect(product.not_related_products.map(&:id)).to eq([other_product.id]) }
      it { expect(related_product.not_related_products.map(&:id)).to eq([other_product.id]) }
      it { expect(other_product.not_related_products.map(&:id).sort).to eq([product.id, related_product.id].sort) }
    end
  end
end
