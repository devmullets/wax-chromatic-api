class CreateArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.text :bio
      t.date :year_formed
      t.date :year_ended
      t.timestamps
    end
  end
end
