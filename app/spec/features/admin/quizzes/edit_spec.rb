require 'rails_helper'

describe 'editing of quiz' do
  stub_authorization!

  let!(:quiz) { create(:quiz, title: 'things', description: 'long description') }
  let!(:grade) { create(:grade, title: 'Grade MEga title', quiz: quiz) }

  before(:each) { visit spree.edit_admin_quiz_path(quiz.id) }

  it 'should update quiz' do
    expect(find('#quiz_title').value).to eq 'things'
    expect(find('#quiz_description').value).to eq 'long description'

    fill_in 'quiz[title]', with: 'title up'
    fill_in 'quiz[description]', with: 'Test description 111'
    find('fieldset[data-hook="update_quiz"] button').click

    expect(page).to have_selector '#quiz_title[value="title up"]'
    expect(page).to have_selector '#quiz_description', text: 'Test description 111'
  end

  context 'grades block' do
    it 'should create grade for editable quiz' do
      find('#grades .title input').set 'Senior grade'
      find('fieldset[data-hook="manage_grades"] button').click

      expect(page).to have_selector '#grades input[value="Senior grade"]'
    end

    it 'should go to the grade edit page' do
      find('.grade a[data-action="edit"]').click

      expect(page).to have_content 'Update grade'
    end

    it 'should delete grade', js: true do
      expect(page).to have_selector '#grades input[value="Grade MEga title"]'

      page.evaluate_script('window.confirm = function() { return true; }')
      find('.grade .spree_remove_fields').click

      expect(page).to_not have_selector '#grades input[value="Grade MEga title"]'
    end
  end
end
