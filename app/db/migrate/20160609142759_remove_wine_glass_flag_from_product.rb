class RemoveWineGlassFlagFromProduct < ActiveRecord::Migration
  def change
    remove_column :spree_products, :is_wine_glass, :boolean, default: false, null: false
  end
end
