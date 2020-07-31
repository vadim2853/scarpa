require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'creating new topic' do
  stub_authorization!

  before :each do
    @product = create :product
  end

  it 'should visit creating new topic page' do
    visit spree.admin_product_topics_path(@product)

    expect(find('#new_topic_link span')).to have_content 'New topic'
    click_link 'new_topic_link'
    expect(page).to have_css('form#new_topic')
  end

  it 'should create new topic' do
    visit spree.new_admin_product_topic_url(@product)

    within(:css, '#new_topic') do
      fill_in 'topic[title]', with: 'Topic title Blah-blah-blah'
      attach_file('topic[image]', File.absolute_path("#{Rails.root}/spec/fixtures/images/slide.jpg"))
      fill_in 'topic[link]', with: 'http://google.com'
      click_button('Create')
    end

    expect(page).to have_content 'Topic has been successfully created!'
    expect(page).to have_content 'Topic title Blah-blah-blah'
    expect(page).to have_content 'http://google.com'
  end
end
