class AddWineGlassIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :wine_glass_id, :integer
  end
end
