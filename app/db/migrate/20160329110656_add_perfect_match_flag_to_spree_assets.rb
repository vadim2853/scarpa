class AddPerfectMatchFlagToSpreeAssets < ActiveRecord::Migration
  def change
    add_column :spree_assets, :is_perfect_match, :boolean, default: false, null: false
  end
end
