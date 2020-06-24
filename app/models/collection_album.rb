class CollectionAlbum < ApplicationRecord
  belongs_to :collection
  belongs_to :album
end
