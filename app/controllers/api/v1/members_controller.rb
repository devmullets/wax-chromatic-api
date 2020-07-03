module Api
  module V1
    class MembersController < ApplicationController
      def index
        members = Member.all
        render json: members
      end
    end
    
  end
  
end
