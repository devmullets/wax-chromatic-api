class Member < ApplicationRecord
  has_many :member_artists
  has_many :artists, through: :member_artists
end
