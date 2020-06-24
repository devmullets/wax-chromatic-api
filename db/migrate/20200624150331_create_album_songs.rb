class CreateAlbumSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :album_songs do |t|
      t.belongs_to :song
      t.belongs_to :album
      t.timestamps
    end
  end
end
