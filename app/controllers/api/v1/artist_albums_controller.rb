module Api
  module V1
    class ArtistAlbumsController < ApplicationController
      def index
        artist_albums = ArtistAlbum.all
        render json: artist_albums
      end
    end
    
  end
  
end
