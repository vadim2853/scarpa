require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe ProductRelation do
  let(:product_1) { create :product }
  let(:product_2) { create :product }

  describe 'validations' do
    describe 'unique relation' do
      before { ProductRelation.create(related_id: product_1.id, inverse_related_id: product_2.id) }

      it 'should not create straight' do
        related_product = ProductRelation.create(related_id: product_1.id, inverse_related_id: product_2.id)

        expect(related_product.errors.messages[:related_product]).to be_present
      end

      it 'should not create inverse' do
        related_product = ProductRelation.create(related_id: product_2.id, inverse_related_id: product_1.id)

        expect(related_product.errors.messages[:related_product]).to be_present
      end
    end
  end

  describe 'methods' do
    describe '.delete_relations' do
      before { ProductRelation.create(related_id: product_1.id, inverse_related_id: product_2.id) }

      let(:delete_straight) { described_class.delete_relations(product_1.id, product_2.id) }
      let(:delete_inverse) { described_class.delete_relations(product_2.id, product_1.id) }

      it { expect { delete_straight }.to change { ProductRelation.count }.by(-1) }
      it { expect { delete_inverse }.to change { ProductRelation.count }.by(-1) }
    end
  end
end
