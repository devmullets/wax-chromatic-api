module Api
  module V1
    module Artists
      # service checks if the artist exists in our database
      # uses the discogs_id
      class CheckArtist
        def call(artist_id)
          # binding.pry
          if Artist.where(d_artist_id: artist_id).exists?
            artist = Artist.find_by(d_artist_id: artist_id)
            binding.pry
          else
            url = ::RestClient::Request.execute(
              method: :get, url: "https://api.discogs.com/artists/#{artist_id}",
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/vnd.discogs.v2.plaintext+json',
                'Authorization': "Discogs key=#{discogs_key}, secret=#{discogs_secret}",
                'User-Agent': 'WaxChromatics/v0.1 +https://waxchromatics.com'
              }
            )

            artist = Artists::CreateArtist.call(
              generate_artist_obj(parsed_json: JSON.parse(url), artist_id: artist_id)
            )
            binding.pry
          end
          artist
        end

        private

        def generate_artist_obj(parsed_json:, artist_id:)
          {
            'name' => parsed_json['name'],
            'bio' => parsed_json['profile'],
            'website' => nil,
            'd_artist_id' => artist_id
          }
        end

        def discogs_key
          ENV['DISCOGS_KEY']
        end

        def discogs_secret
          ENV['DISCOGS_SECRET']
        end
      end
    end
  end
end
