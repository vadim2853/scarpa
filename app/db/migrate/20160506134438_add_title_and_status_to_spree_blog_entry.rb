class AddTitleAndStatusToSpreeBlogEntry < ActiveRecord::Migration
  def change
    add_column :spree_blog_entries, :title, :string
    add_column :spree_blog_entries, :status, :integer, default: 0
  end
end
