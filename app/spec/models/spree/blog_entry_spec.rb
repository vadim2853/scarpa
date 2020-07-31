require 'rails_helper'

describe Spree::BlogEntry do
  describe 'validations' do
    it { should validate_presence_of :preview_text }
    it { should validate_presence_of :posted_on }
    it { should validate_presence_of :full_text }
    it { should validate_presence_of :title }
    it { should validate_presence_of :user }
  end

  describe 'asociations' do
    it { should belong_to(:user) }
  end

  describe 'methods' do
    include_examples 'by month scope'
  end
end
