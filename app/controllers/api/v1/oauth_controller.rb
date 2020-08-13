module Api
  module V1
    class OauthController < ApplicationController

      def temp_oauth
        # {url}/oauth/temp
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
        wax_user = params[:wax]
        time = Time.now.to_i.to_s
        # 
        # possibly need to refactor to match code using RestClient, previously wasn't working, i think it had more to do with the format of the auth header
        # access discogs access_token and supply all oauth info
        # 
        url = URI("https://api.discogs.com/oauth/access_token")
          https = Net::HTTP.new(url.host, url.port)
          https.use_ssl = true
          request = Net::HTTP::Post.new(url)
          request["Authorization"] = "OAuth oauth_consumer_key=\"#{discogs_key}\", oauth_nonce=\"#{time}\", oauth_token=\"#{oauth_token}\", oauth_signature=\"#{discogs_secret}\", oauth_signature_method=\"PLAINTEXT\", oauth_timestamp=\"#{time}\", oauth_verifier=\"#{oauth_verifier}\""
          request["Content-Type"] = "application/x-www-form-urlencoded"
          request["User-Agent"] = "WaxChromatics/v0.1 +https://waxchromatics.com"
        response = https.request(request)
        req_token = CGI.parse(response.read_body)
        # 
        # now to test that we have OAuth access by getting user identity from discogs
        # currently no error handling for revoked user, will need to add
        # 
        perm_oauth_token = req_token['oauth_token'][0]
        perm_oauth_token_secret = req_token['oauth_token_secret'][0]
        user_info = ::RestClient::Request.execute(method: :get, url: "https://api.discogs.com/oauth/identity", 
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded', 
            'Authorization': "OAuth oauth_consumer_key=#{discogs_key}, oauth_nonce=#{time}, oauth_signature=#{discogs_secret_no_token + '&' + perm_oauth_token_secret}, oauth_signature_method=PLAINTEXT, oauth_timestamp=#{time}, oauth_token=#{perm_oauth_token}",
            'User-Agent': "WaxChromatics/v0.1 +https://waxchromatics.com"
            })
        user_info_json = JSON.parse(user_info)
        # byebug
        # 
        # now we update the user with the permanent tokens for future use, tokens are valid until user revokes them in discogs admin panel
        # 
        # discogs returns: {"id"=>123456, "username"=>"name", "resource_url"=>"https://api.discogs.com/users/#{username}", "consumer_name"=>"app name?"}
        user = User.update(wax_user, oauth_token: perm_oauth_token, discogs_id: user_info_json['id'], name: user_info_json['username'], oauth_token_secret: perm_oauth_token_secret)

        render json: user
      end
    end
  end
end