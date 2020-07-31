module Spree
  class Question < ActiveRecord::Base
    default_scope { order(position: :asc) }
    acts_as_list

    store_accessor :variants

    enum variants_type: %i(v_choose_one v_choose_many v_match v_reorder)

    belongs_to :grade

    validates :grade, :title, presence: true
    validates :variants_type, presence: true, unless: :new_record?
    validate  :ensure_variant_number_for_match_type, if: :v_match?

    class << self
      def right_answer?(params)
        question = find(params[:question_id])

        case question.variants_type
        when 'v_choose_one'
          question.variants.find { |v| to_bool(v['right']) }['title'] == params[:answers][:title]

        when 'v_match'
          params[:answers][:matching]

        when 'v_reorder'
          question.variants == params[:answers]
        end
      end

      def to_bool(str)
        ActiveRecord::Type::Boolean.new.type_cast_from_database(str)
      end
    end

    private

    def ensure_variant_number_for_match_type
      t_count = 0
      f_count = 0
      variants.each { |v| self.class.to_bool(v['to_match']) ? (t_count += 1) : (f_count += 1) }

      errors.add(:base, 'Columns are not match') if t_count != f_count
    end
  end
end
