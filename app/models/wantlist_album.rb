class WantlistAlbum < ApplicationRecord
  belongs_to :wantlist
  belongs_to :album
end
