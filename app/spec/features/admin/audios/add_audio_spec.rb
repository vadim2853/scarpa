require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'creating new audio' do
  stub_authorization!

  before(:each) { @product = create :product }

  it 'should visit creating new audio page' do
    visit spree.admin_product_audios_path(@product)

    expect(find('#new_audio_link span')).to have_content 'New audio'
    click_link 'new_audio_link'
    expect(page).to have_css('form#new_audio')
  end

  it 'should create new audio' do
    visit spree.new_admin_product_audio_url(@product)

    within(:css, '#new_audio') do
      fill_in 'audio[title]', with: 'Audio title Blah-blah-blah'
      fill_in 'audio[title_it]', with: 'IT Audio title Blah-blah-blah'
      fill_in 'audio[description]', with: 'Audio description Blah-blah-blah'
      fill_in 'audio[description_it]', with: 'IT Audio description Blah-blah-blah'
      attach_file('audio[image]', File.absolute_path("#{Rails.root}/spec/fixtures/images/slide.jpg"))
      fill_in 'audio[audio_mp3]', with: 'test.mp3'
      fill_in 'audio[audio_ogg]', with: 'test.ogg'
      fill_in 'audio[audio_wav]', with: 'test.wav'

      click_button('Create')
    end

    expect(Spree::Audio.count).to eq 1
    expect(page).to have_content 'Audio has been successfully created!'
    expect(find('.audios_table tbody tr')).to have_content 'Audio title Blah-blah-blah'
    expect(find('.audios_table tbody tr')).to have_content 'Audio description Blah-blah-blah'

    expected_src = "/test_uploads/spree/audios/#{Spree::Audio.first.id}/images/icons/slide.jpg"
    expect(find('.audios_table img')['src'].include?(expected_src)).to be_truthy
  end
end
