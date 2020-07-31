class AddTextColorToSpreeWineries < ActiveRecord::Migration
  def change
    add_column :spree_wineries, :text_color, :string
  end
end
