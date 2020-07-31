class AddImageToSpreeAudios < ActiveRecord::Migration
  def change
    add_attachment :spree_audios, :image
  end
end
