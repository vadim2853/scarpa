class AddOrderToFeaturedItesm < ActiveRecord::Migration
  def change
    add_column :spree_featured_items, :position, :integer, default: 0
  end
end
