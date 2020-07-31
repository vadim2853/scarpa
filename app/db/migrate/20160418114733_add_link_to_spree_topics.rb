class AddLinkToSpreeTopics < ActiveRecord::Migration
  def change
    add_column :spree_topics, :link, :string
  end
end
