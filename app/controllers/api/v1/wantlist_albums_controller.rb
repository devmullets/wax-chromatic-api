module Api
  module V1
    class WantlistAlbumsController < ApplicationController
      def index
        wantlist_albums = WantlistAlbum.all
        render json: wantlist_albums
      end

      def show
        # user_wantlist = WantlistAlbum.where(album_id: params[:id])
        # user_wantlist = WantlistAlbum.find_by(album_id: params[:id])
        # render json: user_wantlist
      end

      def destroy
        vinyl = WantlistAlbum.find(params[:id])
        vinyl.destroy
      end

      def create
        wantlist = WantlistAlbum.create(create_wantlist_item_params) 
        render json: wantlist 
      end

      private
      def create_wantlist_item_params
        params.require(:wantlist_album).permit(:wantlist_id, :album_id)
      end
    end
    
  end
  
end
