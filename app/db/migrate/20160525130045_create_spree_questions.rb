class CreateSpreeQuestions < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    create_table :spree_questions do |t|
      t.integer :grade_id, index: true, null: false
      t.string :title
      t.text :description
      t.integer :position
      t.integer :variants_type, default: 0
      t.hstore :variants, null: false, default: [], array: true
      t.timestamps null: true
    end

    add_index :spree_questions, :variants
  end
end
