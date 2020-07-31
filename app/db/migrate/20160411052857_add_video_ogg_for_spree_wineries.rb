class AddVideoOggForSpreeWineries < ActiveRecord::Migration
  def change
    add_column :spree_wineries, :video_ogg, :text
  end
end
