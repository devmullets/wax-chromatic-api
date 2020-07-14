module Api
  module V1
    class MembersController < ApplicationController
      def index
        members = Member.all
        render json: members
      end

      def show
        member = Member.find(params[:id])
        render json: member
      end
    end
    
  end
  
end
