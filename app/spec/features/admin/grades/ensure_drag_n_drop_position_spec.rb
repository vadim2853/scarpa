require 'rails_helper'

describe 'ensure drag and drop (position of viewing)' do
  stub_authorization!

  let!(:quiz) { create(:quiz) }

  before do
    @position_ids = []
    @position_ids << create(:grade, title: 'First', quiz: quiz).id
    @position_ids << create(:grade, title: 'Second', quiz: quiz).id

    visit spree.edit_admin_quiz_path(quiz)
  end

  it 'should change positions of grades', js: true do
    selectors_ids = @position_ids.map { |id| "spree_grade_#{id}" }

    expect_table_with(selectors_ids)

    turn_on_drag_n_drop_js

    execute_script(
      "$('#spree_grade_#{@position_ids.first} .handle')"\
      ".simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
    )

    sleep 2

    expect_table_with(selectors_ids.reverse)

    visit spree.edit_admin_quiz_path(quiz)

    expect_table_with(selectors_ids.reverse)
  end

  def expect_table_with(ids)
    expect(find('.sortable').all('tbody tr').map { |tr| tr['id'] }).to eq ids
  end
end
