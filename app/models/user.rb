class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: { case_sensitive: false }

  has_one :collection
  has_one :wantlist
end
