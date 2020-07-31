class AddPercentFieldToSpreeGradesResults < ActiveRecord::Migration
  def change
    add_column :spree_grades_results, :percent, :integer
  end
end
