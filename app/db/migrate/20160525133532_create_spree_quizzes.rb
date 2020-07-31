class CreateSpreeQuizzes < ActiveRecord::Migration
  def change
    create_table :spree_quizzes do |t|
      t.string :title
      t.string :description
      t.integer :position
      t.timestamps null: true
    end
  end
end
