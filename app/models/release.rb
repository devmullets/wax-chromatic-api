class Release < ApplicationRecord
  has_many :albums

  has_many :artist_releases
  has_many :artists, through: :artist_releases
end
