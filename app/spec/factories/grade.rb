FactoryGirl.define do
  factory :grade, class: Spree::Grade do |s|
    quiz
    sequence(:number)
    s.title 'Test title'
    s.description 'description content'
  end
end
