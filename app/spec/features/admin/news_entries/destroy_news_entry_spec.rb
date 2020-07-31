require 'rails_helper'

describe 'Destroy news entry', js: true do
  stub_authorization!

  Given { create :news_entry }

  When { visit spree.admin_news_entries_path }
  When { find('.delete-resource').click }
  When { page.driver.browser.switch_to.alert.accept }

  Then { expect(find('#content-header')).to have_content 'News entries' }
  And  { expect(find('tbody')).not_to have_css('tr') }
end
