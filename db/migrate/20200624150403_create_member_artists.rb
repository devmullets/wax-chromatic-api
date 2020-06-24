class CreateMemberArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :member_artists do |t|

      t.timestamps
    end
  end
end
