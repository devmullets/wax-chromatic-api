class CreateMemberArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :member_artists do |t|
      t.belongs_to :member
      t.belongs_to :artist
      t.boolean :active_member
      t.timestamps
    end
  end
end
