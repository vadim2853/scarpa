class AddValueArrayToSpreeProductProperties < ActiveRecord::Migration
  def change
    add_column :spree_product_properties, :value_array, :text, array: true, default: []
  end
end
