class NumberOfGrade < ActiveRecord::Migration
  def change
    add_column :spree_grades, :number, :integer
  end
end
