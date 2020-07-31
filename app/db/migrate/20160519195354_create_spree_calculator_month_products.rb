class CreateSpreeCalculatorMonthProducts < ActiveRecord::Migration
  def change
    create_table :spree_calculator_month_products, id: false do |t|
      t.integer :calculator_month_id, index: true, null: false
      t.integer :product_id, index: true, null: false
    end
  end
end
