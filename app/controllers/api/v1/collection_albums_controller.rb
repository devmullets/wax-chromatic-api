module Api
  module V1
    class CollectionAlbumsController < ApplicationController
      def index
        collection_albums = CollectionAlbum.all
        render json: collection_albums
      end

      def show
        user_collection = CollectionAlbum.where(collection_id: params[:id])
        render json: user_collection
      end

      def create
        collection = CollectionAlbum.create(create_collection_item_params) 
        render json: collection 
      end

      private
      def create_collection_item_params
        params.require(:collection_album).permit(:collection_id, :album_id)
      end
    end
    
  end
  
end
