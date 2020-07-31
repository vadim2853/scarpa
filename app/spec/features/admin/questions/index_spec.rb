require 'rails_helper'

describe 'questions index page' do
  stub_authorization!

  it 'should show list of questions' do
    create :question

    visit spree.admin_questions_path

    expect(page).to have_content 'Listing questions'

    expect(page).to have_content 'Grade'
    expect(page).to have_content 'Test title'

    expect(page).to have_content 'Title'
    expect(page).to have_content 'Test title'

    expect(page).to have_content 'Description'
    expect(page).to have_content 'description content'

    expect(page).to have_content 'Variants type'
    expect(page).to have_content 'Choose one'
  end
end
