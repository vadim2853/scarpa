class ChangeVideoLinkToVideoMp4ForSpreeWineries < ActiveRecord::Migration
  def change
    rename_column :spree_wineries, :video_link, :video_mp4
  end
end
