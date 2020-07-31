class AddDetailsColumnsForSpreeMapMarkers < ActiveRecord::Migration
  def change
    add_attachment :spree_map_markers, :image
    add_column :spree_map_markers, :dependency, :integer, default: 0
    add_column :spree_map_markers, :name_it, :string
    add_column :spree_map_markers, :address_it, :text
    add_column :spree_map_markers, :description, :text
    add_column :spree_map_markers, :description_it, :text
    add_column :spree_map_markers, :rating, :integer
    add_column :spree_map_markers, :work_time, :text
    add_column :spree_map_markers, :work_time_it, :text
  end
end
