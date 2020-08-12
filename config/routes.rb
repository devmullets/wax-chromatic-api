Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :artist_releases
      resources :album_genres
      resources :genres
      resources :wantlist_albums
      resources :collection_albums
      resources :member_artists
      resources :artist_albums
      resources :artist_songs
      resources :album_songs
      resources :members
        get 'members/active/:artist_id', to: 'members#active_members', as: :members_active
      resources :artists
      resources :songs
      resources :albums
        get 'albums/release/', to: 'albums#release_id', as: :albums_release_id
        get 'albums/vinyl/:id', to: 'albums#vinyl', as: :albums_vinyl
      resources :wantlists
      resources :collections
      resources :users#, only: [:create] #, defaults: {format: :json}
        post 'users/login', to: 'auth#create'
        get 'users/profile', to: 'users#profile'
        # might need to rename these to work with bcrypt
        # get 'users/login/', to: 'users#temp_oauth', as: :user_temp_oauth
        # get 'users/authenticate', to: 'users#get_user', as: :user_authenticate
      resources :releases
        get 'releases/d_release_id/:id', to: 'releases#release_id', as: :releases_release_id # handles query params
        get 'releases/artist/:id', to: 'releases#get_releases', as: :releases_get_releases
      resources :label_albums
      resources :labels
    end
  end    
end
