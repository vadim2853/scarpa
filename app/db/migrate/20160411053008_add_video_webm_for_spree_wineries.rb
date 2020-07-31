class AddVideoWebmForSpreeWineries < ActiveRecord::Migration
  def change
    add_column :spree_wineries, :video_webm, :text
  end
end
