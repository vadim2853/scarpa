FactoryGirl.define do
  factory :store, class: Spree::Store do |s|
    s.name 'Test Store'
    s.url 'localhost'
    s.mail_from_address 'teststore@example.com'
    s.code 'spree'
    s.default true
    s.created_at Time.zone.today
    s.updated_at Time.zone.today
  end
end
