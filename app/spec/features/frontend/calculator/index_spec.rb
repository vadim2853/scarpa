require 'rails_helper'

describe 'Calculator page', js: true do
  Given!(:months) { (1..12).map { |m| create(:month, name: Date::MONTHNAMES[m], rate: 1) } }

  When { visit_as_adult party_calculator_path }

  context 'calculator is not displayed' do
    context 'when there are no default backgrounds' do
      Given { create :background, is_default: false }

      Then { expect(page).to have_no_css('.calculator_buying') }
    end

    context 'when there are no events' do
      Given { create :background, is_default: true }
      Given { Spree::Calculator::Event.delete_all }

      Then { expect(page).to have_no_css('.calculator_buying') }
    end
  end

  context 'calculator displayed correctly when event and default background exist' do
    Given!(:event) { create :event }
    Given { create :background, event: event, is_default: true }

    Then { expect(page).to have_css('.calculator_buying') }
    And  { expect(page).to have_css('.calculator_result a[href="/wines"]') }
    And  { expect(find('.calculator_buying')['style']).to have_content('slide.jpg') }
  end
end
