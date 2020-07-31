module Spree
  class GradesResult < ActiveRecord::Base
    belongs_to :user
    belongs_to :grade
    belongs_to :nomination

    validates :user, :grade, :score, :percent, presence: true
  end
end
