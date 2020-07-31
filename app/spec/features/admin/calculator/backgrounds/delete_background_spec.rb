require 'rails_helper'

describe 'deleting of calculator background' do
  stub_authorization!

  it 'should delete calculator background', js: true do
    calculator_background = create :background
    visit spree.admin_calculator_backgrounds_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{calculator_background.id}").click
    sleep 5

    expect(page).to have_content 'Background has been successfully removed!'
  end
end
