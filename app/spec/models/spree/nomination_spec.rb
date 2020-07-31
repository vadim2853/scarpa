require 'rails_helper'

describe Spree::Nomination do
  describe 'default scope' do
    let!(:nomination_one) { create(:nomination, position: 2) }
    let!(:nomination_two) { create(:nomination, position: 1) }

    it 'orders by ascending position' do
      expect(Spree::Nomination.all).to eq [nomination_two, nomination_one]
    end
  end

  describe 'asociations' do
    it { should belong_to(:grade) }
  end

  describe 'validations' do
    it { should validate_presence_of :grade }
    it { should validate_presence_of :title }
    it { should validate_presence_of :min }
  end
end
