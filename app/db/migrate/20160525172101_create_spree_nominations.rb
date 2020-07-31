class CreateSpreeNominations < ActiveRecord::Migration
  def change
    create_table :spree_nominations do |t|
      t.integer :grade_id, index: true, null: false
      t.string :title
      t.integer :min
      t.integer :position
    end
  end
end
