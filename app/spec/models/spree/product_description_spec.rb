require 'rails_helper'

describe Spree::ProductDescription do
  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :kind }
    it { should validate_presence_of :product }
  end
end
