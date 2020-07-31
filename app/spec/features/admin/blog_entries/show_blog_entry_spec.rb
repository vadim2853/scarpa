require 'rails_helper'

describe 'Show blog entry' do
  stub_authorization!

  Given(:preview_text) { 'Some text for preview' }
  Given(:view_count) { 108 }
  Given(:full_text) { 'Some full text' }
  Given(:posted_on) { '2010-01-01' }
  Given(:author) { create :blog_user, login: login }
  Given(:login) { 'ololo' }

  Given(:blog_entry) do
    create(
      :blog_entry,
      preview_text: preview_text,
      view_count: view_count,
      full_text: full_text,
      posted_on: posted_on,
      user: author
    )
  end

  When { visit spree.admin_blog_entry_path(blog_entry) }

  Given(:subject) { find('#content') }

  Then { is_expected.to have_content(preview_text) }
  And  { is_expected.to have_content(view_count) }
  And  { is_expected.to have_content(full_text) }
  And  { is_expected.to have_content(posted_on) }
  And  { is_expected.to have_content(login) }
end
