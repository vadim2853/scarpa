require 'rails_helper'

describe Spree::Password do
  describe 'validations' do
    let!(:admin) { create :admin_user }
    let(:user_params) do
      {
        user: admin,
        current_password: 'secret',
        password: '123456',
        password_confirmation: '123456'
      }
    end

    it { should validate_presence_of :current_password }
    it { should validate_presence_of :password }
    it { should validate_presence_of :password_confirmation }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_length_of(:password_confirmation).is_at_least(6) }

    context 'check current password' do
      it 'should validate current password' do
        expect(Spree::Password.new(user_params).valid?).to be_truthy
      end

      it 'should return error: current password is invalid' do
        password = Spree::Password.new(user_params.merge!(current_password: 'invalid'))
        password.change
        expect(password.errors.messages[:current_password]).to eq ['is invalid!']
      end
    end

    context 'check matching of passwords' do
      it 'should match each other' do
        password = Spree::Password.new(user_params)
        expect(password.change).to be_truthy
      end

      it 'should return error: passwords do not match' do
        password = Spree::Password.new(user_params.merge!(password_confirmation: '654321'))
        password.change
        expect(password.errors.messages[:password_confirmation]).to eq ['do not match!']
      end
    end
  end
end
