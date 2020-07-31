class AddReviewLinkToSpreeMapMarkers < ActiveRecord::Migration
  def change
    add_column :spree_map_markers, :review_link, :text
  end
end
