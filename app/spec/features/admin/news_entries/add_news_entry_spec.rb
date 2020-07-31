require 'rails_helper'

describe 'Add news entry' do
  stub_authorization!

  Given(:preview_text) { 'Some text for preview' }

  When { visit spree.new_admin_news_entry_path }
  When { fill_in 'news_entry[title]', with: 'New member of the Scarpa family' }
  When { fill_in 'news_entry[preview_text]', with: preview_text }
  When { fill_in 'news_entry[full_text]', with: 'Some text for full' }
  When { choose('news_entry_status_published') }
  When { click_button('Create') }

  Given(:subject) { find('tbody tr') }

  Then { expect(find('#content-header')).to have_content 'News entries' }
  And  { expect(page).to have_content 'New member of the Scarpa family' }
  And  { expect(page).to have_content 'published' }
  And  { is_expected.to have_css('td', text: preview_text) }
end
