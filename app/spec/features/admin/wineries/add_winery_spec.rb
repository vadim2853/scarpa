require 'rails_helper'

describe 'creating new winery' do
  stub_authorization!

  it 'should create new winery' do
    visit spree.new_admin_winery_path

    fill_in 'winery[title]', with: 'Test record'
    fill_in 'winery[title_it]', with: 'IT Test record'
    fill_in 'winery[description]', with: 'Test description'
    fill_in 'winery[description_it]', with: 'IT Test description'
    fill_in 'winery[video_mp4]', with: 'http://d18izmg1gcfkjo.cloudfront.net/hmbia.com/HMB.mp4'
    fill_in 'winery[video_ogg]', with: 'http://d18izmg1gcfkjo.cloudfront.net/hmbia.com/HMB.ogg'
    fill_in 'winery[video_webm]', with: 'http://d18izmg1gcfkjo.cloudfront.net/hmbia.com/HMB.webm'
    choose('winery_status_published')
    attach_file('winery[image]', File.absolute_path("#{Rails.root}/spec/fixtures/images/slide.jpg"))

    click_button('Create')

    expect(page).to have_content 'Listing wineries'
    expect(page).to have_content 'Winery has been successfully created!'
    expect(page).to have_content 'published'
  end
end
