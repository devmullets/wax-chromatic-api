class CreateArtistAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_albums do |t|

      t.timestamps
    end
  end
end
