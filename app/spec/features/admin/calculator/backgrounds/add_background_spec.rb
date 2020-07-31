require 'rails_helper'

describe 'creating new calculator background' do
  stub_authorization!

  let!(:month) { create :month }

  before { create :event, name: 'Wedding' }

  it 'should create new calculator background', js: true do
    visit spree.new_admin_calculator_background_path

    fill_in 'calculator_background[guests]', with: '12321'
    attach_file('calculator_background[image]', File.absolute_path("#{Rails.root}/spec/fixtures/images/slide.jpg"))
    execute_script "$('#calculator_background_calculator_month_id').val('#{month.id}').trigger('change');"

    click_button('Create')

    expect(page).to have_content 'Listing backgrounds'
    expect(page).to have_content 'Wedding'
    expect(page).to have_content 'July'
    expect(page).to have_content '12321'
  end
end
