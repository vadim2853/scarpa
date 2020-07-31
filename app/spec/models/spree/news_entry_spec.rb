require 'rails_helper'

describe Spree::NewsEntry do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :preview_text }
    it { should validate_presence_of :posted_on }
    it { should validate_presence_of :full_text }
    it { should define_enum_for(:status).with [:draft, :published] }
  end

  describe 'methods' do
    describe '#not_related_news_entries' do
      let(:news_entry) { create :news_entry }
      let(:related_news_entry) { create :news_entry }
      let!(:other_news_entry) { create :news_entry }

      before { Spree::NewsEntryRelation.create(related_id: news_entry.id, inverse_related_id: related_news_entry.id) }

      it { expect(news_entry.not_related_news_entries.map(&:id)).to eq([other_news_entry.id]) }
      it { expect(related_news_entry.not_related_news_entries.map(&:id)).to eq([other_news_entry.id]) }
      it do
        expect(
          other_news_entry.not_related_news_entries.map(&:id).sort
        ).to eq([news_entry.id, related_news_entry.id].sort)
      end
    end

    include_examples 'by month scope'
  end
end
