class AddNominationIdToGradesResults < ActiveRecord::Migration
  def change
    add_column :spree_grades_results, :nomination_id, :integer
  end
end
