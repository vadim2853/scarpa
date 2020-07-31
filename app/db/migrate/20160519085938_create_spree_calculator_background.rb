class CreateSpreeCalculatorBackground < ActiveRecord::Migration
  def change
    create_table :spree_calculator_backgrounds do |t|
      t.belongs_to :calculator_event
      t.integer :calculator_month_id
      t.attachment :image
      t.integer :guests
      t.boolean :is_default, default: false
    end

    add_index :spree_calculator_backgrounds, :calculator_event_id
    add_index :spree_calculator_backgrounds, :calculator_month_id
  end
end
