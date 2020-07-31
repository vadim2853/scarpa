class RemoveNominationIdFromSpreeGradesResults < ActiveRecord::Migration
  def change
    remove_column :spree_grades_results, :nomination_id
  end
end
