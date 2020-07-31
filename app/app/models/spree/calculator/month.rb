class Spree::Calculator::Month < ActiveRecord::Base
  include CommonForCalculator

  has_many :month_products, foreign_key: 'calculator_month_id'
  has_many :products, through: :month_products

  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
