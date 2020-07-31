class Spree::Calculator::MonthProduct < ActiveRecord::Base
  belongs_to :product

  validate :relation_uniqueness, on: :create

  def relation_uniqueness
    related = self.class.where(calculator_month_id: calculator_month_id, product_id: product_id)

    errors.add(:related_product, 'The products are already related') if related.any?
  end

  def self.delete_relations(calculator_month_id, product_id)
    where(calculator_month_id: calculator_month_id, product_id: product_id).delete_all
  end
end
