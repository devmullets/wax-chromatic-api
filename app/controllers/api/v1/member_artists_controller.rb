module Api
  module V1
    class MemberArtistsController < ApplicationController
      def index
        bandmembers = MemberArtist.all
        render json: bandmembers
      end
    end
    
  end
  
end
