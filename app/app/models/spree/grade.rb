module Spree
  class Grade < ActiveRecord::Base
    default_scope { order(position: :asc) }

    PASSING_SCORE = 80

    belongs_to :quiz
    has_many :questions, -> { order(:position) }, dependent: :destroy
    has_many :nominations, -> { order(:position) }, dependent: :destroy
    has_many :grades_results, dependent: :destroy

    validates :title, :number, presence: true

    accepts_nested_attributes_for :questions, reject_if: -> (q) { q[:title].blank? }, allow_destroy: true
    accepts_nested_attributes_for :nominations, reject_if: -> (n) { n[:title].blank? }, allow_destroy: true

    acts_as_list

    def user_result(user_id)
      grades_results.find_by(user_id: user_id)
    end
  end
end
