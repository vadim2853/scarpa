class ProductRelation < ActiveRecord::Base
  validate :relation_uniqueness, on: :create

  def relation_uniqueness
    related = self.class.where(related_id: related_id, inverse_related_id: inverse_related_id)
    invert_related = self.class.where(related_id: inverse_related_id, inverse_related_id: related_id)

    errors.add(:related_product, 'The products are already related') if related.any? || invert_related.any?
  end

  def self.delete_relations(product_id, related_product_id)
    where(related_id: product_id, inverse_related_id: related_product_id).delete_all
    where(related_id: related_product_id, inverse_related_id: product_id).delete_all
  end
end
