require 'rails_helper'
require 'spree/testing_support/factories/stock_location_factory'

describe 'ensure registrations of new users', js: true do
  before :each do
    ROLES.each do |item|
      Spree::Role.create(
        name: item[:name],
        description: item[:description],
        category: item[:category]
      )
    end

    Spree::Store.create(
      code: '1',
      name: 'test',
      mail_from_address: 'localhost:3000',
      url: 'localhost:3000'
    )

    visit_as_adult root_path

    find('.header_login').click
  end

  it 'should find registration form' do
    expect(find('.login')).to be_visible

    within(:css, '#new_spree_user', visible: true) do
      expect(page).to have_css '#reg_email'
      expect(page).to have_css '#reg_password'
      expect(page).to have_css '#reg_password_confirmation'

      expect(find('.checkbox_open_select', visible: :all).visible?).to be_falsy
      find('label.check_label_text').click
      expect(find('.checkbox_open_select').visible?).to be_truthy

      expect(page).to have_css '.sing_up_button'
    end
  end

  context 'checking validations' do
    it 'should check by emptiness of fields' do
      find('.sing_up_button').click

      expect(page).to have_content "Email can't be blank;"
      expect(page).to have_content "Password can't be blank"
    end
  end

  context 'creation users with different roles' do
    ROLES.each do |role|
      next unless role[:category] == 'business'

      it "should create new user with #{role[:name]} role" do
        within(:css, '#new_spree_user') do
          fill_in 'spree_user[email]', with: "#{role[:name]}@example.com"
          fill_in 'spree_user[password]', with: '1233456'
          fill_in 'spree_user[password_confirmation]', with: '1233456'

          find('label.check_label_text').click

          execute_script(%{
            $('#spree_user_spree_role_ids').val(
              $('#spree_user_spree_role_ids option').filter(function () {
                return $(this).html() == '#{role[:description].upcase}';
              }).val()
            ).trigger('change');
          })
          sleep 1

          click_button('Enter Scarpa')
        end

        expect(page).to have_selector "a[data-href='#{cabinet_path}']"
        expect(Spree::User.count).to eq 1
        expect(Spree::User.first.spree_roles.take.name).to eq role[:name]
      end
    end
  end
end
