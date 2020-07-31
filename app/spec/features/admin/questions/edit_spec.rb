require 'rails_helper'

describe 'editing of question' do
  stub_authorization!

  let!(:question) { create(:question, title: 'things', description: 'long description') }

  before(:each) { visit spree.edit_admin_question_path(question.id) }

  it 'should update question' do
    expect(find('#question_title').value).to eq 'things'
    expect(find('#question_description').value).to eq 'long description'

    fill_in 'question[title]', with: 'title up'
    fill_in 'question[description]', with: 'Test description 111'
    find('fieldset[data-hook="update_question"] button').click

    expect(page).to have_selector '#question_title[value="title up"]'
    expect(page).to have_selector '#question_description', text: 'Test description 111'
  end

  context 'ensure variants_type: "Choose one"', js: true do
    it 'should create 2 wrong and one right variants' do
      within(:css, 'fieldset[data-hook="manage_variants"]') do
        first('tr .title input').set 'Variant 1'

        find('#new_add_question_variant').click
        first('tr .title input').set 'Variant 2'

        find('#new_add_question_variant').click
        first('tr .title input').set 'Variant 3'
        first('tr .right_variant input').click

        turn_on_drag_n_drop_js
        execute_script(
          "$('tr:nth-child(1) .handle') .simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
        )

        find('button').click

        expect(all('tr .title input').map(&:value)).to eq ['Variant 2', 'Variant 1', 'Variant 3']
        expect(all('tr .right_variant input').map(&:checked?)).to eq [false, false, true]
      end
    end
  end

  context 'ensure variants_type: "Choose many"', js: true do
    it 'should create 1 wrong and 2 right variants' do
      execute_script("$('#question_variants_type').val('v_choose_many').trigger('change');")
      expect(page).to have_content 'VARIANTS TYPE: "CHOOSE MANY"'
      sleep 1

      within(:css, 'fieldset[data-hook="manage_variants"]') do
        first('tr .title input').set 'Variant 1'

        find('#new_add_question_variant').click
        first('tr .title input').set 'Variant 2'
        first('tr .right_variant input').click

        find('#new_add_question_variant').click
        first('tr .title input').set 'Variant 3'
        first('tr .right_variant input').click

        turn_on_drag_n_drop_js
        execute_script(
          "$('tr:nth-child(1) .handle') .simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
        )

        find('button').click

        expect(all('tr .title input').map(&:value)).to eq ['Variant 2', 'Variant 1', 'Variant 3']
        expect(all('tr .right_variant input').map(&:checked?)).to eq [true, false, true]
      end
    end
  end

  context 'ensure variants_type: "Choose match"', js: true do
    it 'should create correct match of table rows' do
      execute_script("$('#question_variants_type').val('v_match').trigger('change');")
      expect(page).to have_content 'VARIANTS TYPE: "MATCHING TABLE ROWS"'
      sleep 1

      within(:css, 'fieldset[data-hook="manage_variants"]') do
        first('.left_variants tr .title input').set 'Variant 1'
        first('.right_variants tr .title input').set 'Variant 2'

        find('.spree_add_variants').click
        first('.left_variants tr .title input').set 'Variant 2'
        first('.right_variants tr .title input').set 'Variant 1'

        turn_on_drag_n_drop_js
        execute_script(
          "$('.right_table_box tr:nth-child(1) .handle')"\
          ".simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
        )
      end

      first('button[type="submit"]').click

      expect(all('.left_variants tr .title input').map(&:value)).to eq ['Variant 2', 'Variant 1']
      expect(all('.right_variants tr .title input').map(&:value)).to eq ['Variant 2', 'Variant 1']
    end
  end

  context 'ensure variants_type: "Choose reorder"', js: true do
    it 'should create correct list' do
      execute_script("$('#question_variants_type').val('v_reorder').trigger('change');")
      expect(page).to have_content 'VARIANTS TYPE: "REORDER (PUT IN THE CORRECT ORDER)"'
      sleep 1

      within(:css, 'fieldset[data-hook="manage_variants"]') do
        first('tr .title input').set 'Variant 1'

        find('#new_add_question_variant').click
        first('tr .title input').set 'Variant 3'

        find('#new_add_question_variant').click
        first('tr .title input').set 'Variant 2'

        turn_on_drag_n_drop_js
        execute_script(
          "$('tr:nth-child(2) .handle') .simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
        )

        find('button').click

        expect(all('tr .title input').map(&:value)).to eq ['Variant 2', 'Variant 1', 'Variant 3']
      end
    end
  end
end
