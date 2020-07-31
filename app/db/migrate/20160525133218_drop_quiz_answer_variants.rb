class DropQuizAnswerVariants < ActiveRecord::Migration
  def up
    drop_table :quiz_answer_variants
  end

  def down
    create_table :quiz_answer_variants
  end
end
