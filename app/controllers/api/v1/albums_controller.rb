module Api
  module V1
    class AlbumsController < ApplicationController
      def index
        albums = Album.all
        render json: albums
      end 

      def album_id
        releases = Album.where(d_release_id: params[:id])
        render json: releases
      end
      
      def create
        album = Album.create(create_album_params) 
        render json: album 
      end 
      
      def release_id 
        releases = Album.where(d_release_id: params[:id])
        render json: releases
      end

      def show
        album = Album.find_by(d_album_id: params[:id])
        render json: album
        # album = check_album(params[:id])
        # render json: album
      end


      private
      def create_album_params
        params.require(:album).permit(:title, :released, :size, :amount_pressed, :color, :notes, :d_album_id, :d_release_id, :cat_no, :release_id, :thumb)
      end

    end
  end
end
