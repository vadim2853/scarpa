class AddTextSideToWineries < ActiveRecord::Migration
  def change
    add_column :spree_wineries, :text_side, :string
  end
end
