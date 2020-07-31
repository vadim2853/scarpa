class AddProducerToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :producer, :string
  end
end
