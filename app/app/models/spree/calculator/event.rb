class Spree::Calculator::Event < ActiveRecord::Base
  include CommonForCalculator

  has_many :backgrounds, foreign_key: 'calculator_event_id', dependent: :destroy
  has_many :event_products, foreign_key: 'calculator_event_id'
  has_many :products, through: :event_products

  validates :name, :red_rate, :white_rate, presence: true
  validates :red_rate, :white_rate, numericality: { greater_than_or_equal_to: 0 }
end
