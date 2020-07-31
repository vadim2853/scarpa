require 'rails_helper'

shared_examples_for 'correct working winery video blocks' do
  it 'ensure presence and possibility for viewing videos' do
    [@first_winary.id, @second_winary.id].each do |id|
      within(:css, "#block_#{id}") do
        find('.about_btn-play').click

        expect(page).to have_css '.about_video', visible: true
        expect(find('.about_video source[type="video/mp4"]', visible: false)['src']).to include 'http://cloud/test.mp4'
        expect(find('.about_video source[type="video/ogg"]', visible: false)['src']).to include 'http://cloud/test.ogg'
        expect(find('.about_video source[type="video/webm"]', visible: false)['src']).to include 'http://cloud/test.webm'

        find('.about_video_close').click
        expect(page).to have_css '.about_video', visible: false
      end
    end
  end
end

describe 'ensure UX of wineries page', js: true do
  before do
    @second_winary = create :winery, title: 'Test tit2'
    @first_winary = create :winery, text_color: 'white', text_side: 'right'

    visit_as_adult winery_path
  end

  it 'should find wineries titles' do
    expect(page).to have_selector "#block_#{@first_winary.id} .about_name", text: 'Test title'
    expect(page).to have_selector "#block_#{@second_winary.id} .about_name", text: 'Test tit2'
  end

  it 'should find correct play-texts for show-video buttons' do
    expect(page).to have_selector "#block_#{@first_winary.id} .play-text", text: 'SHOW ME TEST TITLE'
    expect(page).to have_selector "#block_#{@second_winary.id} .play-text", text: 'SHOW ME TEST TIT2'
  end

  it 'should check blocks sides (left | right)' do
    expect(find("#block_#{@first_winary.id}")).to have_css '.right'
    expect(find("#block_#{@first_winary.id}")).to have_css '.white'

    expect(find("#block_#{@second_winary.id}")).to have_css '.left'
    expect(find("#block_#{@second_winary.id}")).to have_css '.black'
  end

  context 'video blocks depending on the DOM loading' do
    before { visit_as_adult winery_path }

    describe 'regular page loading' do
      it_should_behave_like 'correct working winery video blocks'
    end

    describe 'turbolinks page loading' do
      before { page.execute_script('Turbolinks.visit("/winery")') }

      it_should_behave_like 'correct working winery video blocks'
    end
  end
end
