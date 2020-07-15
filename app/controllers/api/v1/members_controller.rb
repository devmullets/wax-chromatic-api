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
        # Article.includes(:comments).where(comments: { visible: true })
        # Category.joins(articles: [{ comments: :guest }, :tags])
        # current_members = Artist.find(params[:artist_id]).members.joins(member_artist: :active)

        # vinyl = Album.find(params[:id])
        # band = Album.find(params[:id]).release.artist
        # render json: vinyl.as_json.merge(artist: band)

        current_members = Artist.find(params[:artist_id]).members
        render json: current_members.as_json(:include => :member_artists)
      end
    end
    
  end
  
end
