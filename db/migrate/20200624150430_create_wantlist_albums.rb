class CreateWantlistAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :wantlist_albums do |t|

      t.timestamps
    end
  end
end
