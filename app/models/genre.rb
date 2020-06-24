class Genre < ApplicationRecord
  has_many :album_genres
  has_many :genres, through: :album_genres
end
