require 'rails_helper'

describe 'Wine calculating', js: true do
  Given!(:months) { (1..12).map { |m| create(:month, name: Date::MONTHNAMES[m], rate: 1) } }

  When { visit_as_adult party_calculator_path }
  When { turn_on_drag_n_drop_js }

  context 'when event rate 1 1, month rate 1, 10 guests, 100/0 proportions' do
    Given!(:event_1) { create :event, name: 'first event', red_rate: 1, white_rate: 1 }
    Given { create :background, event: event_1, month: months[5], is_default: true }
    When { select2_single(nil, 'FIRST EVENT') }
    When { move_point('.calculator_range_guests .handle-0', -1000) }
    When { move_point('.calculator_range_guests .handle-0', 180) }
    When { move_point('.calculator_range_place .handle-0', -1000) }
    When { move_point('.calculator_range_place .handle-1', 1000) }
    When { move_point('.calculator_type_wine__red .handle-0', 1000) }

    Then { expect(find('.calculator_result_amount.bottle-red').text).to eq('35') }
    And { expect(page).to have_no_css('.calculator_result_amount.bottle-white') }
  end

  context 'when event rate 1.3 1.5, month rate 1.9, 50 guests, 60/40 proportions', pending: true do
    Given!(:event_2) { create :event, name: 'second event', red_rate: 1.3, white_rate: 1.5 }
    Given(:july) do
      months[5].update_attribute(:rate, 1.9)
      months[5]
    end
    Given { create :background, event: event_2, month: july, is_default: true }
    Given { create :background, event: event_2, month: july, is_default: true }
    When { select2_single(nil, 'SECOND EVENT') }
    When { move_point('.calculator_range_guests .handle-0', 1000) }
    When { move_point('.calculator_range_guests .handle-0', 180) }
    When { move_point('.calculator_range_place .handle-0', -1000) }
    When { move_point('.calculator_range_place .handle-1', 1000) }
    When { move_point('.calculator_type_wine__red .handle-0', -1000) }
    When { move_point('.calculator_type_wine__red .handle-0', 490) }

    Then { expect(find('.calculator_result_amount.bottle-red').text).to eq('260') }
    And  { expect(find('.calculator_result_amount.bottle-white').text).to eq('200') }
  end
end
