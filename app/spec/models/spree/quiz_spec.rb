require 'rails_helper'

describe Spree::Quiz do
  describe 'default scope' do
    let!(:quiz_one) { create(:quiz, position: 2) }
    let!(:quiz_two) { create(:quiz, position: 1) }

    it 'orders by ascending position' do
      expect(Spree::Quiz.all).to eq [quiz_two, quiz_one]
    end
  end

  describe 'asociations' do
    it { should have_many(:grades) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:grades) }
  end
end
