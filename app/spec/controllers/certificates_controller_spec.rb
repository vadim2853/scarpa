require 'rails_helper'

RSpec.describe CertificatesController, type: :controller do
  describe 'GET show' do
    Given!(:result) { create :grades_result }
    render_views

    context 'has a 200 status code' do
      When { get :show, format: :pdf, id: result.id }
      Then { expect(response.status).to eq(200) }
    end
  end
end
