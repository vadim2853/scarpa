require 'rails_helper'

describe 'create new nomination' do
  stub_authorization!

  it 'should create new nomination' do
    create :grade, title: 'Grade title'
    visit spree.new_admin_nomination_path

    fill_in 'nomination[title]', with: 'Test record'
    fill_in 'nomination[min]', with: 10

    click_button('Create')

    expect(page).to have_content 'Listing nominations'
    expect(page).to have_content 'Nomination has been successfully created!'
    expect(page).to have_content 'Test record'
    expect(page).to have_content '10'
    expect(page).to have_content 'Grade title'
  end
end
