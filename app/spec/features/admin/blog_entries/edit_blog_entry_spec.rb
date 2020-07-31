require 'rails_helper'

describe 'Edit blog entry' do
  stub_authorization!

  Given(:preview_text) { 'Some text for preview' }
  Given(:blog_entry) { create :blog_entry, preview_text: preview_text.reverse }

  When { visit spree.edit_admin_blog_entry_path(blog_entry) }
  When { fill_in 'blog_entry[preview_text]', with: preview_text }
  When { click_button('Update') }

  Given(:subject) { find('tbody tr') }

  Then { expect(find('#content-header')).to have_content 'Blog entries' }
  And  { is_expected.to have_css('td', text: preview_text) }
end
