module Api
  module V1
    class UsersController < ApplicationController
      def index
        require 'json'
        # temporarily having the oauth token response in just a general url

        discogs_key = ENV["DISCOGS_KEY"]
        discogs_secret = ENV["DISCOGS_SECRET"]

        time = Time.now.to_i

          url = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/oauth/request_token", 
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded', 
              'Authorization': "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_signature=#{discogs_secret}&, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_callback=https://localhost:3001/profile",
              'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
              })
          # byebug
          req_token = CGI.parse(url.body)
          oauth_url = "https://discogs.com/oauth/authorize?oauth_token=#{req_token['oauth_token'][0]}"
          url_json = { 'discogs' => oauth_url }
          render json: url_json
      end 

      def create
      end 
      
      def get_user 
        require 'faraday'
        # last step in oauth verification, will also check to see if user is in db

        discogs_key = ENV["DISCOGS_KEY"]
        discogs_secret = ENV["DISCOGS_SECRET"]
        oauth_token = params[:oauth_token].to_s
        oauth_verifier = params[:oauth_verifier].to_s
        time = Time.now.to_i.to_s

        # Content-Type: application/x-www-form-urlencoded
        # Authorization:
        #   OAuth oauth_consumer_key="your_consumer_key",
        #   oauth_nonce="random_string_or_timestamp",
        #   oauth_token="oauth_token_received_from_step_2"
        #   oauth_signature="your_consumer_secret&",
        #   oauth_signature_method="PLAINTEXT",
        #   oauth_timestamp="current_timestamp",
        #   oauth_verifier="users_verifier"
        # User-Agent: some_user_agent


        # authorization_header = "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_token=#{oauth_token}, oauth_signature=#{discogs_secret}&, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_verifier=#{oauth_verifier}"
        authorization_header = "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_token=#{oauth_token}, oauth_signature=#{discogs_secret + '&'}, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_verifier=#{oauth_verifier}"
        url = ::RestClient::Request.execute(method: :post, url: "https://api.discogs.com/oauth/access_token", 
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded', 
            # 'Authorization': "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_token=#{oauth_token}, oauth_signature=#{discogs_secret}&, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_verifier=#{oauth_verifier}",
            'Authorization': authorization_header,
            'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com",
            })

        byebug
        puts 'hi'

        parsed_url = JSON.parse(url)
        render json: parsed_url

      end

    end
  end
end
