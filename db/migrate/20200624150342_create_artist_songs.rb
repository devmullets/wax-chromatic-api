class CreateArtistSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_songs do |t|

      t.timestamps
    end
  end
end
