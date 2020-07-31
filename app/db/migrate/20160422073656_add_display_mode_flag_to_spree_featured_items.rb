class AddDisplayModeFlagToSpreeFeaturedItems < ActiveRecord::Migration
  def change
    add_column :spree_featured_items, :display_mode, :integer, default: 0
  end
end
