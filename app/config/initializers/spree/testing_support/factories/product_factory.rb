unless Rails.env.production?
  require 'spree/testing_support/factories/product_factory'

  FactoryGirl.modify do
    factory :base_product, class: Spree::Product do
      producer 'Super producer'
      geographic_setting 'Geographic setting things'
      video_mp4 'http://techslides.com/demos/sample-videos/small.mp4'
      video_ogg 'http://techslides.com/demos/sample-videos/small.ogg'
      video_webm 'http://techslides.com/demos/sample-videos/small.webm'
    end
  end
end
