require 'rails_helper'

describe Spree::Question do
  describe 'default scope' do
    let!(:question_one) { create(:question, position: 2) }
    let!(:question_two) { create(:question, position: 1) }

    it 'orders by ascending position' do
      expect(Spree::Question.all).to eq [question_two, question_one]
    end
  end

  describe 'asociations' do
    it { should belong_to(:grade) }
  end

  describe 'validations' do
    it { should validate_presence_of :grade }
    it { should validate_presence_of :title }

    it 'should validate presence of variants_type' do
      record = create(:question)
      expect(record).to be_valid

      record.variants_type = nil
      record.save
      expect(record).not_to be_valid
    end

    it { should define_enum_for(:variants_type).with %w(v_choose_one v_choose_many v_match v_reorder) }

    context '#ensure variant number for match type' do
      let(:params) do
        {
          grade: create(:grade),
          title: 'tt',
          description: 'dd',
          variants_type: 'v_match',
          variants: [
            { title: '2', to_match: 'false' },
            { title: '1', to_match: 'false' },
            { title: '1', to_match: 'true' },
            { title: '2', to_match: 'true' }
          ]
        }
      end

      it 'should save' do
        expect(build(:question, params)).to be_valid
      end

      it 'should not save and return proper message' do
        params[:variants].shift
        question = build(:question, params)

        expect(question).not_to be_valid
        expect(question.errors.full_messages).to eq ['Columns are not match']
      end
    end
  end
end
