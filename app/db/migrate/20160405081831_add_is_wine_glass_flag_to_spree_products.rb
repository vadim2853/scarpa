class AddIsWineGlassFlagToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :is_wine_glass, :boolean, default: false, null: false
  end
end
