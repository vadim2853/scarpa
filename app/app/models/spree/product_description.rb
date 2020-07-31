class Spree::ProductDescription < ActiveRecord::Base
  enum kind: %i(short long itinerary)

  belongs_to :product

  validates :product, :body, :kind, presence: true

  acts_as_list
end
