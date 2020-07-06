class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.date :released
      t.integer :size
      t.string :color
      t.integer :amount_pressed
      t.text :notes
      t.string :d_release_id
      t.string :d_album_id
      t.string :cat_no
      t.belongs_to :release
      t.timestamps
    end
  end
end
