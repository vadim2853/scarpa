class AddFeaturedItems < ActiveRecord::Migration
  def change
    create_table :spree_featured_items do |t|
      t.integer :item_size, default: 0
      t.string :link_url
      t.string :item_title, null: false
      t.string :item_description
      t.attachment :image
      t.references :spree_product, index: true

      t.timestamps
    end
  end
end