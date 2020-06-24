class MemberArtist < ApplicationRecord
  belongs_to :member
  belongs_to :artist
end
