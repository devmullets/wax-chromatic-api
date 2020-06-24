class CreateWantlists < ActiveRecord::Migration[6.0]
  def change
    create_table :wantlists do |t|
      t.belongs_to :user
      t.timestamps
    end
  end
end
