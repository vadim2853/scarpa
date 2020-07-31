class CreateSpreeWinery < ActiveRecord::Migration
  def change
    create_table :spree_wineries do |t|
      t.string :title
      t.string :title_it
      t.string :video_code
      t.integer :status, default: Spree::Winery.statuses[:draft]
      t.text :description
      t.text :description_it
      t.attachment :image
      t.integer :position
      t.timestamps null: true
    end
  end
end
