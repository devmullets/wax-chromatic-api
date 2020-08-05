# require 'byebug'
module Api
  module V1
    class AlbumsController < ApplicationController
      def index
        albums = Album.all
        render json: albums
      end 

      def album_id
        releases = Album.where(d_release_id: params[:id])
        render json: releases
      end
      
      def create
        album = Album.create(create_album_params) 
        # album_release = AlbumRelease.create(album_release_params)
        render json: album 
      end 
      
      def vinyl
        vinyl = Album.find(params[:id])
        band = Album.find(params[:id]).release.artist

        render json: vinyl.as_json.merge(artist: band)
      end

      def release_id 
        release = params[:album]
        artist = params[:artist]

        discogs_key = ENV["DISCOGS_KEY"]
        discogs_secret = ENV["DISCOGS_SECRET"]

        new_album = Release.where(d_release_id: release).exists?
        # byebug
        if (new_album)
          # new_album = Release.find_by(d_artist_id: artist)
          find_release = Release.find_by(d_release_id: release)
          render json: find_release.as_json(:include => :albums)
        else 
          url = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/masters/#{release}/versions?page=1&per_page=100", 
            headers: {
              'Content-Type': 'application/json', 
              'Accept': 'application/vnd.discogs.v2.plaintext+json', 
              'Authorization': "Discogs key=#{discogs_key}, secret=#{discogs_secret}",
              'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
              })
          # url.headers will let me view how many requests are left, useful for error implementation - tbd
          albums_parse = JSON.parse(url)
          # byebug
          versions = albums_parse["versions"]
          vinyl_versions = versions.select do |version|
            version["major_formats"].include? 'Vinyl'
          end
          # check and see if release is created, if not create it --- brittle as it assumes user selected vinyl release
          new_release = Release.find_or_create_by(d_release_id: release) do |each_release|  
            artist_info = Artist.find(artist)
            each_release.artist = artist_info.name
            each_release.title = vinyl_versions[0]["title"]
            each_release.d_release_id = release
            each_release.d_artist_id = artist
          end

          ArtistRelease.create(artist_id: artist, release_id: new_release.id)

          vinyl_versions.each do |vinyl|
            notes = vinyl["label"] + " - " + vinyl["format"]
            Album.create(
              released: vinyl["released"],
              title: vinyl["title"],
              size: nil,
              amount_pressed: nil,
              color: nil,
              notes: notes,
              cat_no: vinyl["catno"],
              d_album_id: vinyl["id"],
              thumb: vinyl["thumb"],
              release_id: new_release.id
            )
          end

          find_release = Release.find_by(d_release_id: release)
          render json: find_release.as_json(:include => :albums)
        end

        # byebug


      end

      def show
        # album = Album.find_by(d_album_id: params[:id])
        album = Album.find_by(d_album_id: params[:id])
        render json: album
        # album = check_album(params[:id])
        # render json: album
      end


      private
      def create_album_params
        params.require(:album).permit(:title, :released, :size, :amount_pressed, :color, :notes, :d_album_id, :cat_no, :release_id, :thumb)
      end


      
      
    end
  end
end
