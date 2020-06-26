class User < ApplicationRecord
  has_one :collection
  has_one :wantlist
end
