class Label < ApplicationRecord
  has_many :label_albums
  has_many :albums, through: :label_albums
end
