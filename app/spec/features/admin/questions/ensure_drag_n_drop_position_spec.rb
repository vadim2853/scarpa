require 'rails_helper'

describe 'ensure drag and drop (position of viewing)' do
  stub_authorization!

  let!(:quiz) { create(:quiz) }
  let!(:grade) { create(:grade, quiz: quiz) }

  before do
    @position_ids = []
    @position_ids << create(:question, title: 'First', grade: grade).id
    @position_ids << create(:question, title: 'Second', grade: grade).id

    visit spree.edit_admin_grade_path(grade)
  end

  it 'should change positions of questions', js: true do
    selectors_ids = @position_ids.map { |id| "spree_question_#{id}" }

    expect_table_with(selectors_ids)

    turn_on_drag_n_drop_js

    execute_script(
      "$('#spree_question_#{@position_ids.first} .handle')"\
      ".simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
    )

    sleep 2

    expect_table_with(selectors_ids.reverse)

    visit spree.edit_admin_grade_path(grade)

    expect_table_with(selectors_ids.reverse)
  end

  def expect_table_with(ids)
    expect(find('#questions').all('tbody tr').map { |tr| tr['id'] }).to eq ids
  end
end
