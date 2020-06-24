class CreateArtistSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_songs do |t|
      t.belongs_to :artist
      t.belongs_to :song
      t.timestamps
    end
  end
end
