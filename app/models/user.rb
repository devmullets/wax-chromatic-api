class User < ApplicationRecord
  has_secure_password
  validates :email, :wax_username, uniqueness: { case_sensitive: false }

  has_one :collection
  has_one :wantlist
end
