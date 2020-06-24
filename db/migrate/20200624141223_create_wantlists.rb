class CreateWantlists < ActiveRecord::Migration[6.0]
  def change
    create_table :wantlists do |t|

      t.timestamps
    end
  end
end
