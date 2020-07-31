FactoryGirl.define do
  factory :winery, class: Spree::Winery do |s|
    s.title 'Test title'
    s.title_it 'IT title'
    s.video_mp4 'http://cloud/test.mp4'
    s.video_ogg 'http://cloud/test.ogg'
    s.video_webm 'http://cloud/test.webm'
    s.description 'description content'
    s.description_it 'IT description content'
    s.text_color 'black'
    s.text_side 'left'
    s.image { fixture_file_upload "#{Rails.root}/spec/fixtures/images/slide.jpg", 'image/jpg' }
    s.status Spree::Winery.statuses[:published]
    s.created_at Time.zone.today
    s.updated_at Time.zone.today
  end
end
