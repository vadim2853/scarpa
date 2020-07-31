class CreateSpreeGrades < ActiveRecord::Migration
  def change
    create_table :spree_grades do |t|
      t.integer :quiz_id, index: true, null: false
      t.string :title
      t.text :description
      t.integer :position
      t.timestamps null: true
    end
  end
end
