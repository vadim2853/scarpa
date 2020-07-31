FactoryGirl.define do
  factory :grades_result, class: Spree::GradesResult do |s|
    user
    grade
    nomination
    s.percent 50
    s.score 5
  end
end
