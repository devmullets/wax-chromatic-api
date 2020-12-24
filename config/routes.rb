Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'oauth/temp', to: 'oauth#temp_oauth', as: :oauth_temp_oauth
      get 'oauth/success', to: 'oauth#get_user', as: :user_authenticate
      get 'albums/release/', to: 'albums#release_id', as: :albums_release_id
      get 'albums/vinyl/:id', to: 'albums#vinyl', as: :albums_vinyl
      get 'artists/search/', to: 'artists#search', as: :artist_search
      get 'members/active/:artist_id', to: 'members#active_members', as: :members_active
      post 'users/login', to: 'auth#create'
      get 'users/profile', to: 'users#profile'
      get 'releases/d_release_id/:id', to: 'releases#release_id', as: :releases_release_id # handles query params
      get 'releases/artist/:id', to: 'releases#artist_releases', as: :releases_artist_releases

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
      resources :artists
      resources :songs
      resources :albums
      resources :wantlists
      resources :collections
      resources :users # , only: [:create] #, defaults: {format: :json}
      resources :releases
      resources :label_albums
      resources :labels
    end
  end
end
