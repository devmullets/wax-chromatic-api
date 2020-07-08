class CreateArtistReleases < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_releases do |t|
      t.belongs_to :artist
      t.belongs_to :release

      t.timestamps
    end
  end
end
