require 'rails_helper'

describe 'Show news entry' do
  stub_authorization!

  Given(:title) { 'Show title' }
  Given(:preview_text) { 'Some text for preview' }
  Given(:view_count) { 108 }
  Given(:full_text) { 'Some full text' }
  Given(:posted_on) { '2010-01-01' }
  Given(:status) { Spree::NewsEntry.statuses[:draft] }

  Given(:news_entry) do
    create(
      :news_entry,
      title: title,
      preview_text: preview_text,
      view_count: view_count,
      full_text: full_text,
      posted_on: posted_on,
      status: status
    )
  end

  When { visit spree.admin_news_entry_path(news_entry) }

  Given(:subject) { find('#content') }

  Then { is_expected.to have_content(title) }
  And  { is_expected.to have_content(preview_text) }
  And  { is_expected.to have_content(view_count) }
  And  { is_expected.to have_content(full_text) }
  And  { is_expected.to have_content(posted_on) }
  And  { is_expected.to have_content(status) }
end
