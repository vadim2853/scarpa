require 'rails_helper'

describe 'Sliders', js: true do
  def get_points_with_pictures(points_number, step, handler1, handler2 = nil)
    result = {}
    [handler1, handler2].each do |handler|
      next unless handler
      point = find(handler)
      image = point['style'][%r{assets\/(.*?)-}m, 1]
      result[point.text] = image
    end
    (points_number - 1).times do
      move_point(handler1, step)
      point = find(handler1)
      image = point['style'][%r{assets\/(.*?)-}m, 1]
      result[point.text] = image
    end
    result
  end

  Given!(:months) { (1..12).map { |m| create(:month, name: Date::MONTHNAMES[m], rate: 1) } }

  When { visit_as_adult party_calculator_path }
  When { turn_on_drag_n_drop_js }

  context 'guests slider switches backgrounds' do
    Given!(:event) { create :event }
    Given do
      create :background,
             event: event,
             is_default: false,
             guests: 20,
             month: months[11],
             image: fixture_file_upload('/images/slide.jpg', 'image/jpg')
    end
    Given do
      create :background,
             event: event,
             is_default: true,
             guests: 30,
             month: months[11],
             image: fixture_file_upload('/images/calc_wedding.jpg', 'image/jpg')
    end

    When { move_point('.calculator_range_season .handle', 1000) }

    context 'when guests < 20' do
      When { move_point('.calculator_range_guests .handle', 100) }
      Then { expect(find('.calculator_buying')['style']).to have_content('calc_wedding.jpg') }
    end

    pending 'when 20 <= guests < 30' do
      When { move_point('.calculator_range_guests .handle', 300) }
      Then { expect(find('.calculator_buying')['style']).to have_content('slide.jpg') }
    end

    context 'when guests >= 30' do
      When { move_point('.calculator_range_guests .handle', 500) }
      Then { expect(find('.calculator_buying')['style']).to have_content('calc_wedding.jpg') }
    end
  end

  context 'time slider shows hours and pictures' do
    Given { create :background, is_default: true, month: months[0] }
    Given(:hours_with_images) do
      (0..23).each_with_object({}) do |hour, hsh|
        hsh[hour.to_s] = (hour > 5 && hour < 18) ? 'party_range_sun' : 'party_range_moon'
      end
    end

    When { move_point('.calculator_range_place .handle-0', -1000) }
    When { move_point('.calculator_range_place .handle-1', -1000) }
    When(:hours_points) do
      get_points_with_pictures(24, 40, '.calculator_range_place .handle-1', '.calculator_range_place .handle-0')
    end

    Then { expect(hours_points).to eq(hours_with_images) }
  end

  pending 'season slider shows months and pictures' do
    Given { create :background, is_default: true, month: months[0] }
    Given(:months_and_seasons) do
      {
        'JANUARY' => 'winter', 'FEBRUARY' => 'winter', 'MARCH' => 'spring',
        'APRIL' => 'spring', 'MAY' => 'spring', 'JUNE' => 'summer',
        'JULY' => 'summer', 'AUGUST' => 'summer', 'SEPTEMBER' => 'autumn',
        'OCTOBER' => 'autumn', 'NOVEMBER' => 'autumn', 'DECEMBER' => 'winter'
      }
    end

    When { move_point('.calculator_range_season .handle-0', -960) }
    When(:season_points) { get_points_with_pictures(12, 86, '.calculator_range_season .handle-0') }
    Then { expect(season_points).to eq(months_and_seasons) }
  end

  describe 'Add more button' do
    Given { create :background, is_default: true, month: months[0] }
    context 'on guest slider' do
      context 'when point not on the end' do
        Then { expect(page).to have_css('.calculator_range_guests .calculator__add_more.disable') }
      end

      context 'when point on the end' do
        When { move_point('.calculator_range_guests .handle', 1000) }
        Then { expect(page).to have_no_css('.calculator_range_guests .calculator__add_more.disable') }
        And  { expect(page).to have_css('.calculator_range_guests .calculator__add_more') }

        context 'when click button' do
          When { find('.calculator_range_guests .calculator__add_more').click }
          When { move_point('.calculator_range_guests .handle', 1000) }
          Then { expect(find('.calculator_range_guests')).to have_text('100') }
        end
      end
    end

    context 'on place slider' do
      context 'when point not on the end' do
        Then { expect(page).to have_css('.calculator_range_place .calculator__add_more.disable') }
      end

      context 'when point on the end' do
        When { move_point('.calculator_range_place .handle-1', 960) }
        Then { expect(page).to have_css('.calculator_range_place .calculator__add_more') }
        And  { expect(page).to have_no_css('.calculator_range_place .calculator__add_more.disable') }

        pending 'when click button' do
          When { find('.calculator_range_place .calculator__add_more').click }
          Then { expect(find('.calculator_range_place .handle-1')).to have_content('0') }

          context 'when try to click button again' do
            When { move_point('.calculator_range_place .handle-1', 960) }
            Then { expect(page).to have_css('.calculator_range_place .calculator__add_more.disable') }
          end
        end
      end
    end

    context 'on season slider is absent' do
      Then { expect(page).to have_no_css('.calculator_range_season .calculator__add_more') }
    end
  end
end
