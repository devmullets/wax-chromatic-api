class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name
      t.string :website
      t.text :bio
      t.timestamps
    end
  end
end
