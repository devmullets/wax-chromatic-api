class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.date :release_date
      t.integer :size
      t.string :color
      t.integer :amount_pressed
      t.text :notes
      t.string :d_release_id
      t.timestamps
    end
  end
end
