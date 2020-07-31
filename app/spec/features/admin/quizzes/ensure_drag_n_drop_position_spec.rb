require 'rails_helper'

describe 'ensure drag and drop (position of viewing)' do
  stub_authorization!

  before do
    @position_ids = []
    @position_ids << create(:quiz, title: 'First').id
    @position_ids << create(:quiz, title: 'Second').id

    visit spree.admin_quizzes_path
  end

  it 'should change positions of quizzes', js: true do
    selectors_ids = @position_ids.map { |id| "spree_quiz_#{id}" }

    expect_table_with(selectors_ids)

    turn_on_drag_n_drop_js

    execute_script(
      "$('#spree_quiz_#{@position_ids.first} .handle')"\
      ".simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
    )

    sleep 2

    expect_table_with(selectors_ids.reverse)

    visit spree.admin_quizzes_path

    expect_table_with(selectors_ids.reverse)
  end

  def expect_table_with(ids)
    expect(find('.quizzes_index_table').all('tbody tr').map { |tr| tr['id'] }).to eq ids
  end
end
