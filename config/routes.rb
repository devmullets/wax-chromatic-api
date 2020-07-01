Rails.application.routes.draw do
  resources :label_albums
  resources :labels
  namespace :api do
    namespace :v1 do
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
    end
  end    

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
