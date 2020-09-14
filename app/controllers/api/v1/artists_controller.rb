require 'net/http'
require 'json'
require 'base64'

module Api
  module V1
    class ArtistsController < ApplicationController
      def index
        artists = Artist.all
        render json: artists
      end

      def show
        artist = check_artist(params[:id])
        render json: artist
      end

      def check_artist(artist_id) 
        discogs_key = ENV["DISCOGS_KEY"]
        discogs_secret = ENV["DISCOGS_SECRET"]

        new_artist = Artist.where(d_artist_id: artist_id).exists?
        if (new_artist)
          new_artist = Artist.find_by(d_artist_id: artist_id)
        else 
          url = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/artists/#{artist_id}", 
            headers: {
              'Content-Type': 'application/json', 
              'Accept': 'application/vnd.discogs.v2.plaintext+json', 
              'Authorization': "Discogs key=#{discogs_key}, secret=#{discogs_secret}",
              'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
              })
        
          artist_parse = JSON.parse(url)
          new_artist = Artist.find_or_create_by(d_artist_id: artist_id) do |artist|  
            artist.name = artist_parse["name"]
            artist.bio = artist_parse["profile"]
            artist.website = nil
            artist.d_artist_id = artist_id
          end

          member_check(artist_parse, new_artist)
        end
        new_artist
      end

      def search
        discogs_key = ENV["DISCOGS_KEY"]
        discogs_secret = ENV["DISCOGS_SECRET"]

        artist = params[:artist]
        # https://api.discogs.com/database/search?q=${search}&type=artist
        url = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/database/search?q=#{artist}&type=artist", 
          headers: {
            'Content-Type': 'application/json', 
            'Accept': 'application/vnd.discogs.v2.plaintext+json', 
            'Authorization': "Discogs key=#{discogs_key}, secret=#{discogs_secret}",
            'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
            })
      
        artist_parse = JSON.parse(url)
        # byebug
        render json: artist_parse

      end
      
      def member_check(artist_parse, new_artist)
        members = artist_parse["members"]
          members.each do |single_member|
        #     # look to see if band member is in db under another band
            new_member = Member.find_or_create_by(d_member_id: single_member["id"]) do |member|
              member.name = single_member["name"]
              member.bio = nil
              member.d_member_id = single_member["id"]
            end    
            new_member_artist = MemberArtist.create(member_id: new_member.id, artist_id: new_artist.id, active_member: single_member["active"])
          end    
      end

    end
  end
end
