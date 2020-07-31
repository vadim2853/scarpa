class AddTimezoneToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :timezone, :string
  end
end
