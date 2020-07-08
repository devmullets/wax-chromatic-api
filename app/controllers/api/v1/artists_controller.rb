require 'net/http'
require 'json'

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
        url = RestClient.get("https://api.discogs.com/artists/#{artist_id}")
        artist_parse = JSON.parse(url)

        new_artist = Artist.find_or_create_by(d_artist_id: artist_id) do |artist|  
          artist.name = artist_parse["name"]
          artist.bio = artist_parse["profile"]
          artist.website = nil
          artist.d_artist_id = artist_id
        end



        # members = artist_parse["members"]
        #   members.each do |single_member|
        # #     # look to see if band member is in db under another band
        #     Member.find_or_create_by(d_member_id: single_member["id"]) do |member|
        #       member.name = single_member["name"]
        #       member.bio = nil
        #       member.d_member_id = single_member["id"]
        #     end    
        #   end    
        #     new_member = Member.find_by(d_member_id: single_member["id"])
        #     new_artist = Artist.find_by(d_artist_id: artist_id)
        #     MemberArtist.create(member_id: new_member.id, artist_id: new_artist.id, active_member: single_member["active"])

        # find_artist = Artist.find_by(d_artist_id: artist_id) rescue nil
        # if !find_artist
        #     url = RestClient.get("https://api.discogs.com/artists/#{artist_id}")
        #     artist_parse = JSON.parse(url)
            
        #     Artist.create(
        #       name: artist_parse["name"],
        #       bio: artist_parse["profile"],
        #       # website: artist_parse["urls"][0], #need to error handle if any entries are empty, for some reason
        #       website: nil,
        #       d_artist_id: artist_id
        #     )
        #     new_artist = Artist.find_by(d_artist_id: artist_id)

        #     members = artist_parse["members"]
        #     members.each do |single_member|
        #       # look to see if band member is in db under another band
        #       find_member = Member.find_by(d_member_id: single_member["id"]) rescue nil
        #       if !find_member
        #         # band member doesn't exist
        #         Member.create(name: single_member["name"], bio: nil, d_member_id: single_member["id"])
        #       end
                
        #       new_member = Member.find_by(d_member_id: single_member["id"])
        #       MemberArtist.create(member_id: new_member.id, artist_id: new_artist.id, active_member: single_member["active"])
        #     end

        #     new_artist
        # else 
        #     return find_artist
        # end
      end 
    end
  end
end
