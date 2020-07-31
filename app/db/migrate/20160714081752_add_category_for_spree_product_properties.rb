class AddCategoryForSpreeProductProperties < ActiveRecord::Migration
  def change
    add_column :spree_product_properties, :category, :string
  end
end
