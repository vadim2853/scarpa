require 'rails_helper'

describe 'Edit news entry' do
  stub_authorization!

  Given(:preview_text) { 'Some text for preview' }
  Given(:news_entry) { create :news_entry, preview_text: preview_text.reverse }

  When { visit spree.edit_admin_news_entry_path(news_entry) }
  When { fill_in 'news_entry[preview_text]', with: preview_text }
  When { fill_in 'news_entry[title]', with: 'New title' }
  When { choose('news_entry_status_draft') }
  When { click_button('Update') }

  Given(:subject) { find('tbody tr') }

  Then { expect(find('#content-header')).to have_content 'News entries' }
  And  { expect(page).to have_content 'New title' }
  And  { expect(page).to have_content 'draft' }
  And  { is_expected.to have_css('td', text: preview_text) }
end
