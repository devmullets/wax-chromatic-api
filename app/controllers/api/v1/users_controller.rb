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
              'Authorization': "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_signature=#{discogs_secret}&, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_callback=https://localhost:3001",
              'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
              })
          # byebug
          req_token = CGI.parse(url.body)
          oauth_url = "https://discogs.com/oauth/authorize?oauth_token=#{req_token['oauth_token'][0]}"
          url_json = { 'discogs' => oauth_url }
          render json: url_json

      end 
    end
  end
end
