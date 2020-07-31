include ActionDispatch::TestProcess
require 'ffaker'
require 'spree/testing_support/factories/product_factory'

FactoryGirl.define do
  factory :featured_item, class: 'Spree::FeaturedItem' do
    item_title 'TestTitle'

    trait :with_product do
      association :spree_product, factory: :product, strategy: :create
    end

    trait :with_image_and_link do
      image { fixture_file_upload "#{Rails.root}/spec/fixtures/images/slide.jpg", 'image/jpg' }
      link_url 'www.example.com'
    end
  end
end
