class CreateLabelAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :label_albums do |t|
      t.belongs_to :album
      t.belongs_to :label
      t.timestamps
    end
  end
end
