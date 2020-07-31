class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :spree_comments do |t|
      t.text :comment
      t.references :commentable, polymorphic: true
      t.integer :root_commentable_id
      t.references :user
      t.string :role, default: 'comments'
      t.timestamps
    end

    add_index :spree_comments, :root_commentable_id
    add_index :spree_comments, :commentable_type
    add_index :spree_comments, :commentable_id
    add_index :spree_comments, :user_id
  end

  def self.down
    drop_table :spree_comments
  end
end
