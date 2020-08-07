Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      get 'releases/d_release_id/:id', to: 'releases#release_id', as: :releases_release_id # handles query params
      get 'albums/release/', to: 'albums#release_id', as: :albums_release_id
      get 'releases/artist/:id', to: 'releases#get_releases', as: :releases_get_releases
      
      get 'members/active/:artist_id', to: 'members#active_members', as: :members_active
      get 'albums/vinyl/:id', to: 'albums#vinyl', as: :albums_vinyl
      
      get 'users/login/', to: 'users#temp_oauth', as: :user_temp_oauth
      get 'users/authenticate', to: 'users#get_user', as: :user_authenticate
      
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
      resources :users
      resources :releases
      resources :label_albums
      resources :labels

    end
  end    

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
