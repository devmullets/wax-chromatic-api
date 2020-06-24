class Wantlist < ApplicationRecord
  belongs_to :user

  has_many :wantlist_albums
  has_many :albums, through: :wantlist_albums
end
