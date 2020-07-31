class CreateSpreeCalculatorEvent < ActiveRecord::Migration
  def change
    create_table :spree_calculator_events do |t|
      t.string :name
      t.float :red_rate, default: 1
      t.float :white_rate, default: 1
    end
  end
end
