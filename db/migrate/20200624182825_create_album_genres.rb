class CreateAlbumGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :album_genres do |t|
      t.belongs_to :genre
      t.belongs_to :album
      t.timestamps
    end
  end
end
