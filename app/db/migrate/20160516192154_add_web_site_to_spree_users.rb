class AddWebSiteToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :web_site, :string
  end
end
