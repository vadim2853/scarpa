require 'rails_helper'

describe 'create new question' do
  stub_authorization!

  it 'should create new question' do
    create :grade
    visit spree.new_admin_question_path

    fill_in 'question[title]', with: 'Test record'
    fill_in 'question[description]', with: 'Test description'

    click_button('Create')

    expect(page).to have_selector '#question_title[value="Test record"]'
    expect(page).to have_selector '#question_description', text: 'Test description'
    expect(page).to have_content 'Question has been successfully created!'
    expect(page).to have_content 'Variants type: "Choose right one"'
  end
end
