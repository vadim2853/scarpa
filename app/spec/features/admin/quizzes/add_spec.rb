require 'rails_helper'

describe 'create new quiz' do
  stub_authorization!

  it 'should create new quiz' do
    visit spree.new_admin_quiz_path

    fill_in 'quiz[title]', with: 'Test record'
    fill_in 'quiz[description]', with: 'Test description'

    click_button('Create')

    expect(page).to have_selector '#quiz_title[value="Test record"]'
    expect(page).to have_selector '#quiz_description', text: 'Test description'
    expect(page).to have_content 'Quiz has been successfully created!'
    expect(page).to have_content 'Grades'
    expect(page).to have_content 'Add grade'
  end
end
