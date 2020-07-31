require 'rails_helper'

describe 'deleting of slide' do
  stub_authorization!

  it 'should delete slide', js: true do
    slide = create :slide
    visit spree.admin_slides_path

    page.evaluate_script('window.confirm = function() { return true; }')
    find("#del_#{slide.id}").click
    sleep 5

    expect(page).to have_content 'Slide has been successfully removed!'
  end
end
