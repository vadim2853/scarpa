require 'rails_helper'

RSpec.describe Spree::Calculator::Event, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :red_rate }
  it { should validate_presence_of :white_rate }
  it { should validate_numericality_of(:white_rate).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:red_rate).is_greater_than_or_equal_to(0) }

  describe 'asociations' do
    it { should have_many(:backgrounds).dependent(:destroy) }
    it { should have_many(:event_products) }
    it { should have_many(:products) }
  end

  context 'when delete event' do
    let!(:event) { create :event }
    let!(:background) { create :background, event: event }

    it 'should delete referenced backgrounds too' do
      expect { event.destroy }.to change { Spree::Calculator::Background.count }.by(-1)
    end
  end
end
