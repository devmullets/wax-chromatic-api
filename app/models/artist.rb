class Artist < ApplicationRecord
  has_many :member_artists
  has_many :members, through: :member_artists

  has_many :artist_albums
  has_many :albums, through: :artist_albums

  has_many :artist_songs
  has_many :songs, through: :artist_songs
  
end
