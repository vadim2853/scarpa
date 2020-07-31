require 'rails_helper'

describe 'editing of calculator background' do
  stub_authorization!

  it 'should update calculator background' do
    calc_background = create :background, guests: '98765432'
    visit spree.edit_admin_calculator_background_path(calc_background.id)

    expect(find('#calculator_background_guests').value).to eq '98765432'

    fill_in 'calculator_background[guests]', with: '112233'
    click_button('Update')

    expect(page).to have_content 'Background has been successfully updated!'
    expect(page).to have_content '112233'
  end
end
