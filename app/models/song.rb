class Song < ApplicationRecord
  has_many :aritst_songs
  has_many :artists, through: :aritst_songs

  has_many :album_songs
  has_many :albums, through: :album_songs
end
