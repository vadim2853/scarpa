class AddIdToSpreeGradesResults < ActiveRecord::Migration
  def change
    add_column :spree_grades_results, :id, :primary_key
  end
end
