class AddDescriptionAndCategoryToSpreeRole < ActiveRecord::Migration
  def change
    add_column :spree_roles, :description, :string
    add_column :spree_roles, :category, :string
  end
end
