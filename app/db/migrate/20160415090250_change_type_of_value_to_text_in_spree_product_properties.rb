class ChangeTypeOfValueToTextInSpreeProductProperties < ActiveRecord::Migration
  def up
    change_column :spree_product_properties, :value, :text
  end

  def down
    change_column :spree_product_properties, :value, :string
  end
end
