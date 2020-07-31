class AddMarkerTypeToSpreeMapMarkers < ActiveRecord::Migration
  def change
    add_column :spree_map_markers, :marker_type, :integer, default: 0
  end
end
