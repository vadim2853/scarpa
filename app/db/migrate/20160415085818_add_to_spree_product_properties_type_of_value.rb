class AddToSpreeProductPropertiesTypeOfValue < ActiveRecord::Migration
  def change
    add_column :spree_product_properties, :type_of_value, :integer,
               default: Spree::ProductProperty.type_of_values[:text]
  end
end
