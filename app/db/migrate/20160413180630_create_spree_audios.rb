class CreateSpreeAudios < ActiveRecord::Migration
  def change
    create_table :spree_audios do |t|
      t.belongs_to :product
      t.string :title
      t.string :title_it
      t.text :description
      t.text :description_it
      t.string :audio_mp3
      t.string :audio_ogg
      t.string :audio_wav
      t.integer :position
      t.timestamps null: true
    end

    add_index :spree_audios, :product_id
  end
end
