class CreateCollectionAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_albums do |t|
      t.belongs_to :collection
      t.belongs_to :album
      t.timestamps
    end
  end
end
