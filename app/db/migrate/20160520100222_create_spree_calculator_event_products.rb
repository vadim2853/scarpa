class CreateSpreeCalculatorEventProducts < ActiveRecord::Migration
  def change
    create_table :spree_calculator_event_products do |t|
      t.integer :calculator_event_id, index: true, null: false
      t.integer :product_id, index: true, null: false
    end
  end
end
