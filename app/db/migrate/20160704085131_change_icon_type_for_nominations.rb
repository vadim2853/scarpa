class ChangeIconTypeForNominations < ActiveRecord::Migration
  def up
    remove_column :spree_nominations, :icon
    add_attachment :spree_nominations, :icon
  end

  def down
    remove_attachment :spree_nominations, :icon
    add_column :spree_nominations, :icon, :string
  end
end
