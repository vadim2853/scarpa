require 'rails_helper'

describe 'Grades show', js: true do
  Given(:blogger) { create :blog_user }

  Given(:params_v_choose_one) { [{ title: '1True', right: 'true' }, { title: '2' }, { title: '3' }] }
  Given(:params_v_reorder) { [{ title: '1' }, { title: '3' }, { title: '2' }] }
  Given(:params_v_match) do
    [
      { title: '1', to_match: false, match_id: 'asdf2jdd' },
      { title: '2', to_match: false, match_id: 'mn3j234h' },
      { title: '11', to_match: true, match_id: 'asdf2jdd' },
      { title: '22', to_match: true, match_id: 'mn3j234h' }
    ]
  end

  Given!(:quiz) { create :quiz }
  Given!(:grade) { create :grade, title: 'Super Grade', quiz: quiz }
  Given!(:success_nomination) { create :nomination, title: 'Successful nomination', grade: grade, min: 3 }
  Given!(:looser_nomination) { create :nomination, title: 'Looser nomination', grade: grade, min: 1 }

  Given!(:q_v_choose_one) { create(:question, title: 'q1', grade: grade, variants: params_v_choose_one) }
  Given!(:q_v_match) { create(:question, variants_type: 2, title: 'q2', grade: grade, variants: params_v_match) }
  Given!(:q_v_reorder) { create(:question, variants_type: 3, title: 'q3', grade: grade, variants: params_v_reorder) }

  context 'should pass grade with normal result (for unregistered user)' do
    When { expect(Spree::GradesResult.count).to eq 0 }
    When { visit_as_adult grade_path(grade) }

    When { expect(page).to have_selector '.grade_container .title', text: 'Q1' }
    When { find('.quizz_radio label', text: /\A1TRUE\z/).click }
    When { click_button('next') }
    When { expect(page).to have_selector '.grade_container .title', text: 'Q2' }
    When { click_button('next') }
    When { expect(page).to have_selector '.grade_container .title', text: 'Q3' }
    When { click_button('next') }

    Then { expect(page).to have_content 'CONGRATULATIONS YOU HAVE SUCCESSFULLY COMPLETED' }
    And  { expect(page).to have_selector '.final_display .grade_name', text: 'Super Grade' }
    And  { expect(page).to have_content 'POINTS OF 1ST GRADE' }
    And  { expect(page).to have_selector '.quizz_congratulations_bottom .red', count: 1 }
    And  { expect(page).to have_selector '.quizz_congratulations_bottom a', count: 4, visible: true }
    And  { expect(Spree::GradesResult.count).to eq 0 }
  end

  context 'should pass grade with normal result (for registered user)' do
    Given { login_as(blogger) }

    When { visit_as_adult grade_path(grade) }

    When { expect(page).to have_selector '.grade_container .title', text: 'Q1' }
    When { find('.quizz_radio label', text: /\A1TRUE\z/).click }
    When { click_button('next') }
    When { expect(page).to have_selector '.grade_container .title', text: 'Q2' }
    When { click_button('next') }
    When { expect(page).to have_selector '.grade_container .title', text: 'Q3' }
    When { click_button('next') }

    Then { expect(page).to have_content 'CONGRATULATIONS YOU HAVE SUCCESSFULLY COMPLETED' }
    And  { expect(page).to have_selector '.final_display .grade_name', text: 'Super Grade' }
    And  { expect(page).to have_content 'POINTS OF 1ST GRADE' }
    And  { expect(page).to have_selector '.quizz_congratulations_bottom .red', count: 1 }
    And  { expect(page).to have_selector '.quizz_congratulations_bottom a', count: 4, visible: true }
    And  { expect(Spree::GradesResult.count).to eq 1 }
  end
end
