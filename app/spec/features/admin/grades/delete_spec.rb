require 'rails_helper'

describe 'deleting of grade' do
  stub_authorization!

  it 'should delete grade', js: true do
    grade = create :grade
    visit spree.admin_grades_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{grade.id}").click

    expect(page).to have_content 'Grade has been successfully removed!'
  end
end
