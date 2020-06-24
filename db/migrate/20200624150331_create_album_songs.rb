class CreateAlbumSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :album_songs do |t|

      t.timestamps
    end
  end
end
