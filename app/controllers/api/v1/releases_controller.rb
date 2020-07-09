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
        # artist_releases = Release.where(d_artist_id: params[:id])
        # render json: artist_releases

        # searches by discogs release id and displays albums that belong to the release
        releases = Release.where(d_release_id: params[:id])
        render json: releases.as_json(:include => :albums)
      
      end 

      def release_id
        release = Release.find_by(d_release_id: params[:id])
        if (!release)
          render json: '404'
        else
          render json: release
        end
      end

      def get_releases
        discogs_key = ENV["DISCOGS_KEY"]
        discogs_secret = ENV["DISCOGS_SECRET"]
        d_artist_id = params[:id]

        url = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/artists/#{d_artist_id}/releases?sort=year&sort_order=asc&page=1&per_page=100", 
          headers: {
            'Content-Type': 'application/json', 
            'Accept': 'application/vnd.discogs.v2.plaintext+json', 
            'Authorization': "Discogs key=#{discogs_key}, secret=#{discogs_secret}",
            'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
            })
      
        artist_releases_parse = JSON.parse(url)
        # go thru each release and filter out the non 'Main' appearances
        artist_releases = artist_releases_parse["releases"]
        releases_main = artist_releases.select do |release|
          release["type"] == 'master' && release["role"] == 'Main'
        end

        render json: releases_main

      end

      private
      def create_release_params
        params.require(:release).permit(:d_release_id, :d_artist_id, :artist, :title)
      end
    end
  end
end