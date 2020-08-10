module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.all
        render json: users
      end 

      def create
      end 

      def show
      end

      def temp_oauth
        # {url}/users/login
        # first step in oauth process, get temp tokens and returns url to redirect user so they can sign in via discogs
        # 
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
      
      def get_user 
        # 
        # final step of oauth dance, takes in all previously supplied info
        # temp token, temp token secret, and verifier
        # oauth 1 is a pain
        # 
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
        # possibly need to refactor to match code using RestClient, previously wasn't working, i think it had more to do with the format of the auth header
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
        # byebug
        user_info = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/oauth/identity", 
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded', 
            'Authorization': "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_signature=#{discogs_secret_no_token + '&' + perm_oauth_token_secret}, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_token=#{perm_oauth_token}",
            'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
            })
        user_info_json = JSON.parse(user_info)
        # byebug
        # 
        # see if user is returning or not
        # 
        # can't decide if it's better to store oauth tokens in local storage of browser vs stripping those out and having the backend handle auth on requests
        # leaving it as local storage for now but have toyed with stripping it out
        # 
        # discogs returns: {"id"=>123456, "username"=>"name", "resource_url"=>"https://api.discogs.com/users/#{username}", "consumer_name"=>"app name?"}
        user_check = User.where(discogs_id: user_info_json['id']).exists?
          if (user_check)
            find_user = User.find_by(discogs_id: user_info_json['id'])
              # user_basic_info = {
              #   'username' => find_user.name,
              #   'discogs_id' => find_user.discogs_id
              # }
            render json: find_user
          else
            new_user = User.create(name: user_info_json['username'], discogs_id: user_info_json['id'], oauth_token: perm_oauth_token, oauth_token_secret: perm_oauth_token_secret)
            Collection.create(user_id: new_user.id)
            Wantlist.create(user_id: new_user.id)

            find_user = User.find_by(discogs_id: user_info_json['id'])
              # user_basic_info = {
              #   'username' => find_user.name,
              #   'discogs_id' => find_user.discogs_id
              # }
            render json: find_user
          end 
      end

    end
  end
end
