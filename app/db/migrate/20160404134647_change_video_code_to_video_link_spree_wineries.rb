class ChangeVideoCodeToVideoLinkSpreeWineries < ActiveRecord::Migration
  def change
    rename_column :spree_wineries, :video_code, :video_link
    change_column :spree_wineries, :video_link, :text
  end
end
