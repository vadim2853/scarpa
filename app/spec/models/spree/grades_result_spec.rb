require 'rails_helper'

describe Spree::GradesResult do
  describe 'asociations' do
    it { should belong_to(:user) }
    it { should belong_to(:grade) }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :grade }
    it { should validate_presence_of :score }
    it { should validate_presence_of :percent }
  end
end
