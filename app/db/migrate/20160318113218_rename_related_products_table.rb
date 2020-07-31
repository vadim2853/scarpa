class RenameRelatedProductsTable < ActiveRecord::Migration
  def change
    rename_table :spree_related_products, :product_relations
  end
end
