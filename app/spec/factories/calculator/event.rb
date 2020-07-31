FactoryGirl.define do
  factory :event, class: Spree::Calculator::Event do |s|
    s.name 'Test event name'
  end
end
