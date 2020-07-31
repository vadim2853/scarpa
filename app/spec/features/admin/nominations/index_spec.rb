require 'rails_helper'

describe 'nominations index page' do
  stub_authorization!

  it 'should show list of nominations' do
    grade = create(:grade, title: 'Special grade')
    5.times { create :nomination, title: 'Nomination title', grade: grade }

    visit spree.admin_nominations_path

    expect(page).to have_content 'Listing nominations'
    expect(page).to have_content 'Special grade', count: 5
    expect(page).to have_content 'Nomination title', count: 5
    expect(page).to have_content '10', count: 5
  end
end
