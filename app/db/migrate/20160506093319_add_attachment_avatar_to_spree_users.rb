class AddAttachmentAvatarToSpreeUsers < ActiveRecord::Migration
  def self.up
    change_table :spree_users do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :spree_users, :avatar
  end
end
