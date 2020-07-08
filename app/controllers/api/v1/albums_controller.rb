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
        # album_release = AlbumRelease.create(album_release_params)
        render json: album 
      end 
      
      def vinyl
        vinyl = Album.find(params[:id])
        band = Album.find(params[:id]).release.artist

        render json: vinyl.as_json.merge(artist: band)
      end

      def release_id 
        releases = Album.where(d_release_id: params[:id])
        # artist = Release.find_by(d_release_id: params[:id]).d_artist_id
        render json: releases.as_json(:include => :release)
      end

      def show
        album = Album.find_by(d_album_id: params[:id])
        render json: album
        # album = check_album(params[:id])
        # render json: album
      end


      private
      def create_album_params
        params.require(:album).permit(:title, :released, :size, :amount_pressed, :color, :notes, :d_album_id, :cat_no, :release_id, :thumb)
      end


      
      
    end
  end
end
