FactoryGirl.define do
  factory :slide, class: Spree::Slide do |s|
    s.title 'Test title'
    s.description 'description content'
    s.image { fixture_file_upload "#{Rails.root}/spec/fixtures/images/slide.jpg", 'image/jpg' }
    s.status Spree::Slide.statuses[:published]
    s.created_at Time.zone.today
    s.updated_at Time.zone.today
  end
end
