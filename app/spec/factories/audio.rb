FactoryGirl.define do
  factory :audio, class: Spree::Audio do |s|
    product
    s.image { fixture_file_upload "#{Rails.root}/spec/fixtures/images/slide.jpg", 'image/jpg' }
    s.title 'Audio title'
    s.title_it 'IT Audio title'
    s.description 'Audio description'
    s.description_it 'IT Audio description'
    s.audio_mp3 'test.mp3'
    s.audio_ogg 'test.ogg'
    s.audio_wav 'test.wav'
    s.created_at Time.zone.today
    s.updated_at Time.zone.today
  end
end
