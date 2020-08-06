class AddDiscogsIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :discogs_id, :string
  end
end
