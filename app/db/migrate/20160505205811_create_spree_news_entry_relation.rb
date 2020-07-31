class CreateSpreeNewsEntryRelation < ActiveRecord::Migration
  def change
    create_table :spree_news_entry_relations, id: false do |t|
      t.integer :related_id, index: true, null: false
      t.integer :inverse_related_id, index: true, null: false
    end
  end
end
