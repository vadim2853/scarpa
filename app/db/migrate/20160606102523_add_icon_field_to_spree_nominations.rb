class AddIconFieldToSpreeNominations < ActiveRecord::Migration
  def change
    add_column :spree_nominations, :icon, :string
  end
end
