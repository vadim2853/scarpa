require 'spree/testing_support/sequences'
require 'spree/testing_support/factories/role_factory'
require 'spree/testing_support/factories/address_factory'

FactoryGirl.define do
  sequence :user_authentication_token do |n|
    "xxxx#{Time.current.to_i}#{rand(1000)}#{n}xxxxxxxxxxxxx"
  end

  factory :user, class: Spree.user_class do
    email { generate(:random_email) }
    login { email }
    password 'secret'
    password_confirmation { password }

    if Spree.user_class.attribute_method? :authentication_token
      authentication_token { generate(:user_authentication_token) }
    end

    after(:build) do |user|
      user.confirmed_at = Time.zone.now
      user.skip_confirmation_notification!
    end

    trait :with_api_key do
      after(:create) do |user, _|
        user.generate_spree_api_key!
      end
    end

    factory :admin_user do
      spree_roles { [Spree::Role.find_by(name: 'admin') || create(:role, name: 'admin')] }
    end

    factory :blog_user do
      first_name 'blogger'
      spree_roles { [Spree::Role.find_by(name: 'blogger') || create(:role, name: 'blogger')] }
    end

    factory :user_with_addresses do |_u|
      bill_address
      ship_address
    end
  end
end
