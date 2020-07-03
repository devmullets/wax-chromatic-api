class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.string :name
      t.text :bio
      t.string :d_member_id
      t.timestamps
    end
  end
end
