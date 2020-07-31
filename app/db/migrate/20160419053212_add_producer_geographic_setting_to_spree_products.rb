class AddProducerGeographicSettingToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :geographic_setting, :string
  end
end
