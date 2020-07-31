require 'rails_helper'

describe 'News index', js: true do
  Given!(:april_entry) { create :news_entry, posted_on: '2015.04.13' }
  Given!(:may_entry) { create :news_entry, posted_on: '2015.05.13' }

  When { visit_as_adult news_index_path }

  context 'has all entries by default' do
    Then { expect(find('.left_side')).to have_css('.article', count: 2) }
    And  { expect(find('.select2-container.archive')).to have_css('.select2-chosen', text: 'ALL') }
  end

  context 'select May' do
    When { select2_single('ALL', 'MAY 2015') }

    Then { expect(find('.left_side')).to have_css('.article', count: 1) }
    And  { expect(find('.article')).to have_link(may_entry.title, href: news_path(may_entry)) }
    And  { expect(find('.select2-container.archive')).to have_css('.select2-chosen', text: 'MAY 2015') }

    context 'select All' do
      When { select2_single('MAY 2015', 'ALL') }

      Then { expect(find('.left_side')).to have_css('.article', count: 2) }
      And  { expect(find('.select2-container.archive')).to have_css('.select2-chosen', text: 'ALL') }
    end
  end

  context 'select April' do
    When { select2_single('ALL', 'APR 2015') }

    Then { expect(find('.left_side')).to have_css('.article', count: 1) }
    And  { expect(find('.article')).to have_link(april_entry.title, href: news_path(april_entry)) }
    And  { expect(find('.select2-container.archive')).to have_css('.select2-chosen', text: 'APR 2015') }
  end
end
