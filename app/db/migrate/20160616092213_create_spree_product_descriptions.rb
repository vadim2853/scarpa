class CreateSpreeProductDescriptions < ActiveRecord::Migration
  def change
    create_table :spree_product_descriptions do |t|
      t.text :body
      t.integer :position
      t.integer :product_id
      t.integer :kind, null: false, default: 0

      t.timestamps null: false
    end
  end
end
