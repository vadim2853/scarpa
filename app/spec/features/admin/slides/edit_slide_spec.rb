require 'rails_helper'

describe 'editing of slide' do
  stub_authorization!

  it 'should update slide' do
    slide = create :slide, title: 'Super things'
    visit spree.edit_admin_slide_path(slide.id)

    expect(find('#slide_title').value).to eq 'Super things'

    fill_in 'slide[title]', with: 'Little update for title'
    click_button('Update')

    expect(page).to have_content 'Little update for title'
  end
end
