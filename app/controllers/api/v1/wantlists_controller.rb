module Api
  module V1
    class WantlistsController < ApplicationController
      def index
        wantlists = Wantlist.all
        render json: wantlists
      end
    end
    
  end
  
end
