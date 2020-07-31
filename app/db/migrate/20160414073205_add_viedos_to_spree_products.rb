class AddViedosToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :video_mp4, :string
    add_column :spree_products, :video_ogg, :string
    add_column :spree_products, :video_webm, :string
  end
end
