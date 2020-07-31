require 'rails_helper'

describe 'deleting of quiz' do
  stub_authorization!

  it 'should delete quiz', js: true do
    quiz = create :quiz
    visit spree.admin_quizzes_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{quiz.id}").click

    expect(page).to have_content 'Quiz has been successfully removed!'
  end
end
