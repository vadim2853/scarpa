require 'rails_helper'

describe Spree::Comment do
  describe 'validations' do
    it { should validate_presence_of :root_commentable_id }
    it { should validate_presence_of :commentable }
    it { should validate_presence_of :comment }
    it { should validate_presence_of :user }
  end

  describe 'asociations' do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }
  end
end
