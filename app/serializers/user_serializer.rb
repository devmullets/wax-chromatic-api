class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :discogs_id, :oauth_token, :oauth_token_secret, :wax_username
end
