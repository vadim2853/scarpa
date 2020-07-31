require 'rails_helper'

describe 'editing of grade' do
  stub_authorization!

  let(:grade) { create(:grade, title: 'things', description: 'long description') }
  let!(:nomination) { create(:nomination, title: 'Special nomination title', grade: grade) }
  let!(:question) { create(:question, title: 'Question title', grade: grade) }

  before(:each) { visit spree.edit_admin_grade_path(grade.id) }

  it 'should update grade' do
    expect(find('#grade_title').value).to eq 'things'
    expect(find('#grade_description').value).to eq 'long description'

    fill_in 'grade[title]', with: 'title up'
    fill_in 'grade[description]', with: 'Test description 111'
    find('fieldset[data-hook="update_grade"] button').click

    expect(page).to have_selector '#grade_title[value="title up"]'
    expect(page).to have_selector '#grade_description', text: 'Test description 111'
  end

  context 'nominations block' do
    it 'should create new nomination' do
      within(:css, 'fieldset[data-hook="manage_nominations"]') do
        find('.title input').set 'Senior grade'
        find('.min input').set 10
        find('button').click

        expect(page).to have_selector 'input[value="Senior grade"]'
        expect(page).to have_selector 'input[value="10"]'
      end
    end

    it 'should go to the nomination edit page' do
      find('fieldset[data-hook="manage_nominations"] a[data-action="edit"]').click

      expect(page).to have_content 'Update nomination'
    end

    it 'should delete nomination', js: true do
      within(:css, 'fieldset[data-hook="manage_nominations"]') do
        expect(page).to have_selector 'input[value="Special nomination title"]'

        page.evaluate_script('window.confirm = function() { return true; }')
        find('.spree_remove_fields').click

        expect(page).to_not have_selector 'input[value="Special nomination title"]'
      end
    end
  end

  context 'questions block' do
    it 'should create new question' do
      within(:css, 'fieldset[data-hook="manage_questions"]') do
        find('.title input').set 'Question 1'
        find('button').click

        expect(page).to have_selector 'input[value="Question 1"]'
      end
    end

    it 'should go to the question edit page' do
      find('fieldset[data-hook="manage_questions"] a[data-action="edit"]').click

      expect(page).to have_content 'Update question'
    end

    it 'should delete question', js: true do
      within(:css, 'fieldset[data-hook="manage_questions"]') do
        expect(page).to have_selector 'input[value="Question title"]'

        page.evaluate_script('window.confirm = function() { return true; }')
        find('.spree_remove_fields').click

        expect(page).to_not have_selector 'input[value="Question title"]'
      end
    end
  end
end
