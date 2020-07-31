require 'rails_helper'

describe 'showing winery' do
  stub_authorization!

  before do
    @winery = create(:winery)

    visit spree.admin_winery_path(@winery)
  end

  it 'should find title of page' do
    expect(page).to have_content 'Show winery'
  end

  it 'should find status block' do
    expect(page).to have_content 'PUBLISHED'
  end

  it 'should find content ( titles and descriptions)' do
    expect(page).to have_content 'Test title'
    expect(page).to have_content 'IT title'

    expect(page).to have_content 'description content'
    expect(page).to have_content 'IT description content'
  end

  it 'should find text settings' do
    expect(find('.text_side')).to have_content 'left'

    expect(find('.text_color')).to have_content 'black'
  end

  it 'should find video links block' do
    expect(find('.video_mp4')).to have_content 'http://cloud/test.mp4'
    expect(find('.video_ogg')).to have_content 'http://cloud/test.ogg'
    expect(find('.video_webm')).to have_content 'http://cloud/test.webm'
  end

  it 'should find image' do
    expect(find('.winery_image img')['src'].include?(@winery.image.url(:small))).to be_truthy
  end
end
