module Api
  module V1
    class AlbumsController < ApplicationController
      def index
        albums = Album.all
        render json: albums
      end 

    end
  end
end
