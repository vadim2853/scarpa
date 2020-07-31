class AddPresentationToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :presentation, :string
    add_column :spree_variants, :hidden, :boolean, default: false
  end
end
