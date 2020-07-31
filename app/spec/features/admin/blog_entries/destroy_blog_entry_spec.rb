require 'rails_helper'

describe 'Destroy blog entry', js: true do
  stub_authorization!

  Given { create :blog_entry }

  When { visit spree.admin_blog_entries_path }
  When { find('.delete-resource').click }
  When { page.driver.browser.switch_to.alert.accept }

  Then { expect(find('#content-header')).to have_content 'Blog entries' }
  And  { expect(find('tbody')).not_to have_css('tr') }
end
