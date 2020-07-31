module Spree
  class Quiz < ActiveRecord::Base
    default_scope { order(position: :asc) }

    has_many :grades, -> { order(:position) }, dependent: :destroy

    validates :title, presence: true

    accepts_nested_attributes_for :grades, reject_if: -> (g) { g[:title].blank? }, allow_destroy: true

    acts_as_list
  end
end
