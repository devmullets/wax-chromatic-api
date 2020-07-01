class LabelAlbum < ApplicationRecord
  belongs_to :label
  belongs_to :album
end
