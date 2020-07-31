require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'adding new product properties', js: true do
  stub_authorization!

  before :each do
    @product = create(:product)

    visit spree.admin_product_product_properties_path(@product)
  end

  describe 'with default forms' do
    it 'should add property with text type' do
      ensure_product_property_form

      within(:css, '#product_properties') do
        fill_in 'product[product_properties_attributes][0][property_name]', with: 'test name'
        fill_in 'product[product_properties_attributes][0][value]', with: 27
      end

      click_button 'Update'

      expect_product_update
      within(:xpath, '//table/tbody/tr[1]') do
        expect(find('.property_group .select2-chosen').text).to eq Spree.t(:other)
        expect(find('.property_name input').value).to eq 'test name'
        expect(find('.value input').value).to eq '27'
        expect(find('.type_of_value .select2-chosen').text).to eq 'text'
      end
    end

    it 'should add property with icon type' do
      within(:css, '#product_properties') do
        execute_script "$('.property_group select').val('wine_aeration').trigger('change');"
        expect(page).to have_selector '.property_group .select2-chosen', text: Spree.t(:wine_aeration)

        execute_script "$('.type_of_value select').val('icon').trigger('change');"
        expect(page).to have_selector '.type_of_value .select2-chosen', text: 'icon'

        execute_script("$('.value select').val(['#{ICONS.keys.first}', '#{ICONS.keys.second}']).trigger('change');")
        expect(page).to have_selector ".value .select2-choices .#{ICONS.keys.first}"
        expect(page).to have_selector ".value .select2-choices .#{ICONS.keys.second}"

        fill_in 'product[product_properties_attributes][0][property_name]', with: 'test name 2'
      end

      click_button 'Update'

      expect_product_update
      within(:xpath, '//table/tbody/tr[1]') do
        expect(find('.property_group .select2-chosen').text).to eq Spree.t(:wine_aeration)
        expect(find('.property_name input').value).to eq 'test name 2'

        expect(all(".value .select2-choices li .#{ICONS.keys.first}").size).to eq 1
        expect(all(".value .select2-choices li .#{ICONS.keys.second}").size).to eq 1

        expect(find('.type_of_value .select2-chosen').text).to eq 'icon'
      end
    end
  end

  describe 'through clicking on "Add Product Properties" button' do
    it 'should add property with text type' do
      find('.spree_add_fields').click
      expect(page).to have_selector '#product_properties tr', count: 2

      ensure_product_property_form

      within(:xpath, '//table/tbody/tr[1]') do
        execute_script %{
          $('#product_properties tr:first .property_group select').val('technical_data').trigger('change');
        }
        expect(find('.property_group .select2-chosen')).to have_content Spree.t(:technical_data)

        find(:css, '.property_name input').set 'super name'
        find(:css, '.value input').set 'some val 2'
      end

      click_button 'Update'

      expect_product_update
      within(:xpath, '//table/tbody/tr[1]') do
        expect(find('.property_group .select2-chosen').text).to eq Spree.t(:technical_data)
        expect(find('.property_name input').value).to eq 'super name'
        expect(find('.value input').value).to eq 'some val 2'
        expect(find('.type_of_value .select2-chosen').text).to eq 'text'
      end
    end

    it 'should add property with icon type' do
      find('.spree_add_fields').click
      expect(page).to have_selector '#product_properties tr', count: 2

      ensure_product_property_form

      within(:css, '#product_properties') do
        execute_script "$('.property_group select').val('perfect_temperature').trigger('change');"
        expect(page).to have_selector '.property_group .select2-chosen', text: Spree.t(:perfect_temperature)

        execute_script "$('.type_of_value select').val('icon').trigger('change');"
        expect(page).to have_selector '.type_of_value .select2-chosen', text: 'icon'

        execute_script("$('.value select').val(['#{ICONS.keys.third}', '#{ICONS.keys.fourth}']).trigger('change');")
        expect(page).to have_selector ".value .select2-choices .#{ICONS.keys.third}"
        expect(page).to have_selector ".value .select2-choices .#{ICONS.keys.fourth}"

        fill_in 'product[product_properties_attributes][0][property_name]', with: 'test name 3'
      end

      click_button 'Update'

      within(:xpath, '//table/tbody/tr[1]') do
        expect(find('.property_group .select2-chosen').text).to eq Spree.t(:perfect_temperature)
        expect(find('.property_name input').value).to eq 'test name 3'

        expect(all(".value .select2-choices li .#{ICONS.keys.third}").size).to eq 1
        expect(all(".value .select2-choices li .#{ICONS.keys.fourth}").size).to eq 1

        expect(find('.type_of_value .select2-chosen').text).to eq 'icon'
      end
    end
  end

  def ensure_product_property_form
    within(:xpath, '//table/tbody/tr[1]') do
      expect(
        find('.property_group .select2-chosen')
      ).to have_content Spree.t(Spree::Property.groups.keys.first)

      expect(find('.property_name input').value).to be_empty
      expect(find('.value input').value).to be_empty
      expect(find('.type_of_value .select2-chosen')).to have_content 'text'
    end
  end

  def expect_product_update
    expect(page).to have_content "Product \"#{@product.name}\" has been successfully updated!"
  end
end
