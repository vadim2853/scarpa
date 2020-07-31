class AddQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :question

      t.timestamps null: false
    end

    create_table :quiz_answer_variants do |t|
      t.references :quiz
      t.string :text
      t.boolean :right_one
    end
  end
end