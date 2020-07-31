FactoryGirl.define do
  factory :background, class: Spree::Calculator::Background do |s|
    event
    month
    s.guests 123
    s.image { fixture_file_upload "#{Rails.root}/spec/fixtures/images/slide.jpg", 'image/jpg' }
  end
end
