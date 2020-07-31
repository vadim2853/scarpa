require 'rails_helper'

describe 'deleting of question' do
  stub_authorization!

  it 'should delete question', js: true do
    question = create :question
    visit spree.admin_questions_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{question.id}").click

    expect(page).to have_content 'Question has been successfully removed!'
  end
end
