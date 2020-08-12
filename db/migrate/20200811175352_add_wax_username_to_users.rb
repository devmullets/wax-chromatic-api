class AddWaxUsernameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :wax_username, :string
  end
end
