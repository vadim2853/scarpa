FactoryGirl.define do
  factory :nomination, class: Spree::Nomination do |s|
    grade
    s.title 'Title content'
    s.icon { fixture_file_upload "#{Rails.root}/spec/fixtures/images/slide.jpg", 'image/jpg' }
    s.min 10
  end
end
