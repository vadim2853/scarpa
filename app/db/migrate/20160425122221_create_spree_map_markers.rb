class CreateSpreeMapMarkers < ActiveRecord::Migration
  def change
    create_table :spree_map_markers do |t|
      t.string :place_id
      t.string :name
      t.text :address
      t.float :lat
      t.float :lng
      t.integer :status, default: Spree::MapMarker.statuses[:draft]
      t.timestamps null: true
    end

    add_index :spree_map_markers, :place_id
  end
end
