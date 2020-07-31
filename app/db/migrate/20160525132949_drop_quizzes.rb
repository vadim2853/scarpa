class DropQuizzes < ActiveRecord::Migration
  def up
    drop_table :quizzes
  end

  def down
    create_table :quizzes
  end
end
