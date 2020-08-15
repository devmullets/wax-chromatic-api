module Api
  module V1
    class CollectionsController < ApplicationController
      def index
        collections = Collection.all
        render json: collections
      end
      def show
        user_collection = Collection.find(params[:id])
        collection_albums = CollectionAlbum.where(collection_id: user_collection.id)
        # A.includes(bees: [:cees, :dees])
        # A.includes( { bees: { cees: {:dees, :ees} } })
        
        # collection_albums = collection.as_json(:include => :album)
        render json: collection_albums.as_json(:include => {:album => {:include => :release}})
      end 
    end
    
  end
  
end
