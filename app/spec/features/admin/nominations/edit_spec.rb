require 'rails_helper'

describe 'editing of nomination' do
  stub_authorization!

  it 'should update nomination' do
    grade = create(:grade)
    nomination = create(:nomination, title: 'things', min: 45, grade: grade)
    visit spree.edit_admin_nomination_path(nomination.id)

    expect(find('#nomination_title').value).to eq 'things'
    expect(find('#nomination_min').value).to eq '45'

    fill_in 'nomination[title]', with: 'title up'
    fill_in 'nomination[min]', with: 10
    find('button').click

    expect(page).to have_content 'Nomination has been successfully updated!'
  end
end
