class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.date :release_date
      t.integer :size
      t.string :color
      t.string :label
      t.timestamps
    end
  end
end
