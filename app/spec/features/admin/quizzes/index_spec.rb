require 'rails_helper'

describe 'showing of quizzes of index page' do
  stub_authorization!

  it 'should show list of quizzes' do
    5.times { create :quiz }

    visit spree.admin_quizzes_path

    expect(page).to have_content 'Quizzes list'
    expect(page).to have_content 'Test title', count: 5
    expect(page).to have_content 'description content', count: 5
  end
end
