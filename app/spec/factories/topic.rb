FactoryGirl.define do
  factory :topic, class: Spree::Topic do |s|
    s.title 'Topic title'
    product
    s.image { fixture_file_upload "#{Rails.root}/spec/fixtures/images/slide.jpg", 'image/jpg' }
    s.link 'http://google.com'
    s.created_at Time.zone.today
    s.updated_at Time.zone.today
  end
end
