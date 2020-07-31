require 'rails_helper'

describe 'Add blog entry' do
  Given(:preview_text) { 'Some text for preview' }
  Given(:admin) { create :admin_user }

  When { login_as(admin) }
  When { visit spree.new_admin_blog_entry_path }
  When { fill_in 'blog_entry[preview_text]', with: preview_text }
  When { fill_in 'blog_entry[full_text]', with: 'Some text for full' }
  When { fill_in 'blog_entry[title]', with: 'Some title' }
  When { click_button('Create') }

  Given(:subject) { find('tbody tr') }

  Then { expect(find('#content-header')).to have_content 'Blog entries' }
  And  { is_expected.to have_css('td', text: preview_text) }
end
