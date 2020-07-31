class CreateSpreeGradesResults < ActiveRecord::Migration
  def change
    create_table :spree_grades_results, id: false do |t|
      t.integer :grade_id, index: true, null: false
      t.integer :user_id, index: true, null: false
      t.integer :score
      t.integer :nomination_id
      t.timestamps null: true
    end
  end
end
