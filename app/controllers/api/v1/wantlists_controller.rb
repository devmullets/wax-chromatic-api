module Api
  module V1
    class WantlistsController < ApplicationController
      def index
        wantlists = Wantlist.all
        render json: wantlists
      end
      def show
        user_collection = Wantlist.find(params[:id])
        collection_albums = WantlistAlbum.where(wantlist_id: user_collection.id)
        # A.includes(bees: [:cees, :dees])
        # A.includes( { bees: { cees: {:dees, :ees} } })
        
        # collection_albums = collection.as_json(:include => :album)
        render json: collection_albums.as_json(:include => {:album => {:include => :release}})
      end 
    end
    
  end
  
end
