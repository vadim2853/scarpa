class AddNameToUser < ActiveRecord::Migration
  def change
    change_table :spree_users do |t|
      t.string :first_name, default: ''
      t.string :last_name, default: ''
    end
  end
end
