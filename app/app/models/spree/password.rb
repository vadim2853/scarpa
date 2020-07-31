module Spree
  class Password
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_accessor :user, :current_password, :password, :password_confirmation

    validates :current_password, :password, :password_confirmation, presence: true
    validates :password, :password_confirmation, length: { minimum: 6 }
    validate  :ensure_passwords

    def initialize(attributes = {})
      self.attributes = attributes
    end

    def attributes=(attributes)
      @user = attributes[:user]
      @current_password = attributes[:current_password]
      @password = attributes[:password]
      @password_confirmation = attributes[:password_confirmation]
    end

    def change
      return unless valid?

      user.password = password
      user.password_confirmation = password_confirmation
      user.save
    end

    private

    def ensure_passwords
      return if errors.messages.present?
      errors.add(:current_password, 'is invalid!') unless user.valid_password?(current_password)
      errors.add(:password_confirmation, 'do not match!') if password != password_confirmation
    end
  end
end
