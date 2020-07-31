class CreateSlides < ActiveRecord::Migration
  def change
    create_table :spree_slides do |t|
      t.string :title
      t.integer :status, default: Spree::Slide.statuses[:draft]
      t.text :description
      t.attachment :image
      t.timestamps null: true
    end
  end
end
