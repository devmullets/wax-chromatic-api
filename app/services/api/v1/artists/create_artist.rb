module Artists
  # service creates the artist in our database
  class CreateArtist < Service
    def call(artist_info)
      binding.pry
    end

    private

    def discogs_key
      ENV['DISCOGS_KEY']
    end

    def discogs_secret
      ENV['DISCOGS_SECRET']
    end
  end
end
