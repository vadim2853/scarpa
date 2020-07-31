require 'rails_helper'

describe 'News show' do
  pending 'fail test' do
    Given!(:news_entry) { create :news_entry, title: 'Lorem title', full_text: 'Full text', posted_on: '2016.05.13' }
    Given!(:related_news_entry) { create :news_entry, title: 'Related title', posted_on: '2015.05.10' }

    When { Spree::NewsEntryRelation.create(related_id: news_entry.id, inverse_related_id: related_news_entry.id) }
    When { visit_as_adult news_path(news_entry) }

    Then { expect(page).to have_selector '.article h2', text: 'Lorem title' }
    And  { expect(page).to have_selector '.article .article__views', text: 2 }
    And  { expect(page).to have_selector '.article .article__text', text: 'Full text' }
    And  { expect(page).to have_selector '.article .article__posted', text: 'Posted on : MAY 13, 2016 by SCARPA' }
    And  { expect(page).to have_selector '.article__related h4', text: 'Related news' }
    And  { expect(page).to have_selector '.article__related_post h2 a', text: 'Related title' }
    And  { expect(page).to have_selector '.article__related_posted', text: 'Posted on : MAY 10, 2015' }
  end
end
