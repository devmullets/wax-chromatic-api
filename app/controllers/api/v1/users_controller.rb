module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorized, only: [:create]

      def index
        users = User.all
        render json: users
      end 

      def create
        user = User.create(user_params)
        if user.valid?
          token = encode_token(user_id: user.id)
          Wantlist.create(user_id: user.id)
          Collection.create(user_id: user.id)
          wantlist = Wantlist.find_by(user_id: user.id)
          collection = Collection.find_by(user_id: user.id)
          render json: { user: UserSerializer.new(user), jwt: token, wantlist: wantlist.id, collection: collection.id }, status: :created
        else
          render json: { error: 'failed to create user' }, status: :not_acceptable
        end
      end 

      def profile
        render json: { user: UserSerializer.new(current_user) }, status: :accepted
      end

      def show
      end

      private
      def user_params
        params.require(:user).permit(:email, :password, :name, :discogs_id, :oauth_token, :oauth_token_secret, :wax_username)
      end
    end
  end
end
