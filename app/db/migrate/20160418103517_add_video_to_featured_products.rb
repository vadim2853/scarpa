class AddVideoToFeaturedProducts < ActiveRecord::Migration
  def change
    add_column :spree_featured_items, :video_mp4, :text
    add_column :spree_featured_items, :video_ogg, :text
    add_column :spree_featured_items, :video_webm, :text
  end
end
