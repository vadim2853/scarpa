FactoryGirl.define do
  factory :question, class: Spree::Question do |s|
    grade
    s.variants_type 0
    s.title 'Test title'
    s.description 'description content'
  end
end
