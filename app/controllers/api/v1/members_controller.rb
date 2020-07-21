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

      def active_members
        current_members = Artist.find(params[:artist_id]).members
        render json: current_members.as_json(:include => :member_artists)
      end
    end
    
  end
  
end
