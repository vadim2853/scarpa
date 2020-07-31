require 'rails_helper'

describe 'editing of winery' do
  stub_authorization!

  it 'should update winery' do
    winery = create :winery, title: 'things'
    visit spree.edit_admin_winery_path(winery.id)

    expect(find('#winery_title').value).to eq 'things'

    fill_in 'winery[title]', with: 'title up'
    click_button('Update')

    expect(page).to have_content 'title up'
  end
end
