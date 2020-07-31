require 'rails_helper'

describe Spree::Grade do
  describe 'default scope' do
    let!(:grade_one) { create(:grade, position: 2) }
    let!(:grade_two) { create(:grade, position: 1) }

    it 'orders by ascending position' do
      expect(Spree::Grade.all).to eq [grade_two, grade_one]
    end
  end

  describe 'asociations' do
    it { should belong_to(:quiz) }
    it { should have_many(:questions) }
    it { should have_many(:nominations) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:questions) }
    it { should accept_nested_attributes_for(:nominations) }
  end
end
