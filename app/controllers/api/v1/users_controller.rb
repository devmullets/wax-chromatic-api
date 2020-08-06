module Api
  module V1
    class UsersController < ApplicationController
      def index
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
          
          url_json = { 
            'discogs' => oauth_url,
            'oauth_token' => req_token['oauth_token'][0],
            'oauth_token_secret' => req_token['oauth_token_secret'][0]
          }

          render json: url_json
      end 

      def create
      end 
      
      def get_user 
        # last step in oauth verification, will also check to see if user is in db
        require "uri"
        require "net/http"

        discogs_key = ENV["DISCOGS_KEY"]
        discogs_secret = ENV["DISCOGS_SECRET"] + '&' + params[:oauth_token_secret]
        discogs_secret_no_token = ENV["DISCOGS_SECRET"]
        oauth_token = params[:oauth_token].to_s
        oauth_verifier = params[:oauth_verifier].to_s
        time = Time.now.to_i.to_s
        url = URI("https://api.discogs.com/oauth/access_token")
        # 
        # possible refactor to match code using RestClient, previously wasn't working
        # 
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["Authorization"] = "OAuth oauth_consumer_key=\"#{discogs_key}\", oauth_nonce=\"#{time}\", oauth_token=\"#{oauth_token}\", oauth_signature=\"#{discogs_secret}\", oauth_signature_method=\"PLAINTEXT\", oauth_timestamp=\"#{time}\", oauth_verifier=\"#{oauth_verifier}\""
        request["Content-Type"] = "application/x-www-form-urlencoded"
        request["User-Agent"] = "WaxChromatics/v0.1 +https://waxchromatics.com"
        
        response = https.request(request)
        req_token = CGI.parse(response.read_body)

        perm_oauth_token = req_token['oauth_token'][0]
        perm_oauth_token_secret = req_token['oauth_token_secret'][0]
        # 
        # now to test that we have OAuth access by getting user identity
        # 
        user_info = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/oauth/identity", 
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded', 
            'Authorization': "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_signature=#{discogs_secret_no_token + '&' + perm_oauth_token_secret}, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_token=#{perm_oauth_token}",
            'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
            })
        # byebug
        # 
        # need to create user in table once logged in
        # 
        # user_info_json = CGI.parse(user_info.body)
        user_info_json = JSON.parse(user_info)
        render json: user_info_json
      end

    end
  end
end
