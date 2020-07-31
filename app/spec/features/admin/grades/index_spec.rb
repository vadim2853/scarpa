require 'rails_helper'

describe 'grade index page' do
  stub_authorization!

  it 'list of grades' do
    5.times { create :grade, title: 'Grade title' }

    visit spree.admin_grades_path

    expect(page).to have_content 'Listing grades'
    expect(page).to have_content 'Grade title', count: 5
    expect(page).to have_content 'description content', count: 5
  end
end
