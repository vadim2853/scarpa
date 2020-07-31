require 'rails_helper'

describe 'creating new slide' do
  stub_authorization!

  it 'should create new slide' do
    visit spree.new_admin_slide_path

    fill_in 'slide[title]', with: 'Test record'
    fill_in 'slide[description]', with: 'Test description'
    choose('slide_status_published')
    attach_file('slide[image]', File.absolute_path("#{Rails.root}/spec/fixtures/images/slide.jpg"))

    click_button('Create')

    expect(page).to have_content 'Listing slides'
    expect(page).to have_content 'Slide has been successfully created!'
    expect(page).to have_content 'published'
  end
end
