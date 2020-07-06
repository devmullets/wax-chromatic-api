module Api
  module V1
    class ReleasesController < ApplicationController
      def index
        releases = Release.all
        render json: releases
      end 

      def create
        new_release = Release.create(create_release_params)
        render json: new_release
      end

      def show
        artist_releases = Release.where(d_artist_id: params[:id])
        render json: artist_releases
      end 

      def release_id
        release = Release.find_by(d_release_id: params[:id])
        if (!release)
          render json: '404'
        else
          render json: release
        end
      end

      private
      def create_release_params
        params.require(:release).permit(:d_release_id, :d_artist_id, :artist, :title)
      end
    end
  end
end