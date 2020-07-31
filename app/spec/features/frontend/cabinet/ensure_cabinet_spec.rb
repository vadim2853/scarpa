require 'rails_helper'

describe 'Cabinet page', js: true do
  Given(:admin) { create :admin_user }

  When { login_as(admin) }
  When { ROLES.each { |r| Spree::Role.create(name: r[:name], description: r[:description], category: r[:category]) } }
  When { visit_as_adult cabinet_path }

  Then { expect(page).to have_content 'ORDER HISTORY' }
  And  { expect(page).to have_content 'CALENDAR' }
  And  { expect(page).to have_content 'SETTINGS' }
  And  { expect(page).to have_selector ".cabinet_right_side a[href='#{logout_path}']", text: 'LOGOUT' }
end
