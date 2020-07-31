class CreateTopic < ActiveRecord::Migration
  def change
    create_table :spree_topics do |t|
      t.belongs_to :product
      t.string :title
      t.attachment :image
      t.integer :position
      t.timestamps null: true
    end
  end
end
