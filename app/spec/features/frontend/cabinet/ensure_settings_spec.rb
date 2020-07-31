require 'rails_helper'

describe 'Settings page', js: true do
  shared_examples 'fill password form' do |current_password, password, password_confirmation|
    When { fill_in 'user[current_password]', with: current_password }
    When { fill_in 'user[password]', with: password }
    When { fill_in 'user[password_confirmation]', with: password_confirmation }
    When { click_button('Change password') }
    When { sleep 2 }
  end

  Given(:user) { create :user, first_name: 'customer' }
  Given(:country) { create :country }
  Given(:hotel_id) { Spree::Role.find_by(name: 'hotel').id }
  Given(:country_id) { country.id }
  Given(:state_id) { Spree::State.find_by(name: 'Kyivska Oblast').id }

  When { create :state, name: 'Kyivska Oblast', country: country }
  When { ROLES.each { |r| Spree::Role.create(name: r[:name], description: r[:description], category: r[:category]) } }
  When do
    user.spree_role_ids = [Spree::Role.last.id]
    user.save
  end

  When { login_as(user) }
  When { visit_as_adult settings_path }

  context 'Form of user information' do
    When { fill_in 'user[first_name]', with: 'Max' }
    When { fill_in 'user[last_name]', with: 'SV' }
    When { fill_in 'user[email]', with: 'test@example.com' }
    When { execute_script("$('select.language').val('italian').trigger('change');") }
    When { execute_script("$('select.timezone').val('Kyiv').trigger('change');") }
    When { execute_script("$('select.role').val('#{hotel_id}').trigger('change');") }
    When { fill_in 'user[web_site]', with: 'https://scarpawine.com' }
    When { execute_script("$('#country_id').val('#{country_id}').trigger('change');") }
    When { sleep 5 }
    When { execute_script("$('#state select').val('#{state_id}').trigger('change');") }
    When { fill_in 'user[default_address_attributes][city]', with: 'Kiev' }
    When { fill_in 'user[default_address_attributes][address1]', with: 'Address test 1' }
    When { fill_in 'user[default_address_attributes][zipcode]', with: '04444' }
    When { click_button('Save') }
    When { sleep 5 }
    When { visit_as_adult settings_path }

    Then { expect(page).to have_selector 'input[name="user[first_name]"][value="Max"]' }
    And  { expect(page).to have_selector 'input[name="user[last_name]"][value="SV"]' }
    And  { expect(page).to have_selector 'input[name="user[email]"][value="test@example.com"]' }
    And  { expect(page).to have_selector '.language .select2-chosen', text: 'ITALIAN' }
    And  { expect(page).to have_selector '.timezone .select2-chosen', text: '(GMT+02:00) KYIV' }
    And  { expect(page).to have_selector '.role .select2-chosen', text: 'HOTEL', visible: true }
    And  { expect(page).to have_selector 'input[name="user[web_site]"][value="https://scarpawine.com"]' }
    And  { expect(page).to have_selector '.country .select2-chosen', text: 'UNITED STATES OF AMERICA' }
    And  { expect(page).to have_selector '#state .select2-chosen', text: 'Kyivska Oblast'.upcase }
    And  { expect(page).to have_selector '#user_default_address_attributes_city[value="Kiev"]' }
    And  { expect(page).to have_selector '#user_default_address_attributes_address1[value="Address test 1"]' }
    And  { expect(page).to have_selector '#user_default_address_attributes_zipcode[value="04444"]' }
  end

  context 'Form of password' do
    context 'Successfully changing' do
      include_examples 'fill password form', 'secret', '123456', '123456'
      When { page.driver.browser.switch_to.alert.accept }
      Then { expect(Spree::User.find_by(first_name: 'customer').valid_password?('123456')).to be_truthy }
    end

    context 'Failures' do
      context 'Empty fields' do
        include_examples 'fill password form', '', '', ''

        Then { expect(page).to have_content "Current password can't be blank" }
        And  { expect(page).to have_content "Password can't be blank" }
        And  { expect(page).to have_content "Password confirmation can't be blank" }
      end

      context 'Failure current password' do
        include_examples 'fill password form', 'failed_pass', '123456', '123456'

        Then { expect(page).to have_content 'Current password is invalid!' }
      end
    end
  end
end
