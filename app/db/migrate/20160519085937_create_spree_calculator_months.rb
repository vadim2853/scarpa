class CreateSpreeCalculatorMonths < ActiveRecord::Migration
  def change
    create_table :spree_calculator_months do |t|
      t.string :name
      t.float :rate, default: 1
    end
  end
end
