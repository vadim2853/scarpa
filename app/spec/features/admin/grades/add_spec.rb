require 'rails_helper'

describe 'create new grade' do
  stub_authorization!

  before { create(:quiz) }

  it 'should create new grade', js: true do
    visit spree.new_admin_grade_path

    execute_script("$('#question_quiz_id').val('1').trigger('change');")
    fill_in 'grade[number]', with: '1'
    fill_in 'grade[title]', with: 'Test record'
    fill_in_ckeditor 'grade_description', with: 'Test description'

    click_button('Create')

    expect(page).to have_selector '#grade_title[value="Test record"]'
    expect(page).to have_content 'Grade has been successfully created!'
    expect(page).to have_content 'Nominations'
    expect(page).to have_content 'ADD NOMINATION'
    expect(page).to have_content 'Questions'
    expect(page).to have_content 'ADD QUESTION'
  end
end
