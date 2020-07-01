class Album < ApplicationRecord
  has_many :album_genres
  has_many :genres, through: :album_genres

  has_many :album_songs
  has_many :songs, through: :album_songs

  has_many :collection_albums
  has_many :collections, through: :collection_albums

  has_many :wantlist_albums
  has_many :wantlists, through: :wantlist_albums

  has_many :artist_albums
  has_many :artists, through: :artist_albums

  has_many :label_albums
  has_many :labels, through: :label_albums
end
