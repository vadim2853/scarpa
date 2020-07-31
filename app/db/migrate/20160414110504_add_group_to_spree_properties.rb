class AddGroupToSpreeProperties < ActiveRecord::Migration
  def change
    add_column :spree_properties, :group, :integer
  end
end
