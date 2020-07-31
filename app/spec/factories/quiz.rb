FactoryGirl.define do
  factory :quiz, class: Spree::Quiz do |s|
    s.title 'Test title'
    s.description 'description content'
  end
end
