class CreateSpreeBlogEntries < ActiveRecord::Migration
  def change
    create_table :spree_blog_entries do |t|
      t.text :preview_text
      t.text :full_text
      t.references :user, index: true
      t.integer :view_count, default: 0
      t.date :posted_on

      t.timestamps null: false
    end
    add_foreign_key :spree_blog_entries, :spree_users, column: :user_id
  end
end
