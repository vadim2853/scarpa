require 'rails_helper'

describe 'Wine type block', js: true do
  Given!(:months) { (1..12).map { |m| create(:month, name: Date::MONTHNAMES[m], rate: 1) } }
  Given { create :background, is_default: true, month: months[0] }

  When { visit_as_adult party_calculator_path }

  context 'shows two sliders with default values 50/50' do
    Then { expect(find('.calculator_type_wine')).to have_css('.calculator_type_wine__red') }
    And  { expect(find('.calculator_type_wine')).to have_css('.calculator_type_wine__white') }
    And  { expect(find('.calculator_type_wine__red .handle-0')).to have_text('50%') }
    And  { expect(find('.calculator_type_wine__white .handle-0')).to have_text('50%') }
  end

  context 'change wine proportions via first slider' do
    When { visit_as_adult party_calculator_path }
    When { turn_on_drag_n_drop_js }
    When { move_point('.calculator_type_wine__red .handle-0', 100) }

    Then { expect(find('.calculator_type_wine__red .handle-0')).to have_text('62%') }
    And  { expect(find('.calculator_type_wine__white .handle-0')).to have_text('38%') }
  end

  context 'change wine proportions via second slider' do
    When { visit_as_adult party_calculator_path }
    When { turn_on_drag_n_drop_js }
    When { move_point('.calculator_type_wine__white .handle-0', 100) }

    Then { expect(find('.calculator_type_wine__red .handle-0')).to have_text('38%') }
    And  { expect(find('.calculator_type_wine__white .handle-0')).to have_text('62%') }
  end
end
