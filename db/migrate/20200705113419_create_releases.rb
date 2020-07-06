class CreateReleases < ActiveRecord::Migration[6.0]
  def change
    create_table :releases do |t|
      t.string :d_release_id
      t.string :d_artist_id
      t.string :title
      t.string :artist
      t.timestamps
    end
  end
end
