require 'rails_helper'

shared_examples 'has admin accessed only' do
  let(:user) { create(:user) }

  it 'Authenticated user try to do described action' do
    sign_in_admin(user)
    visit_as_adult path

    expect(page).to have_content Spree.t(:authorization_failure)
    expect(page).to_not have_content Spree.t(:logged_in_succesfully)
  end

  it 'Unauthenticated visitor try to do described action' do
    visit_as_adult path

    expect(page).to have_content Spree.t(:admin_login)
  end
end
