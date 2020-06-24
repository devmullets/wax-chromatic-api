class Collection < ApplicationRecord
  belongs_to :user

  has_many :collection_albums
  has_many :albums, through: :collection_albums
end
