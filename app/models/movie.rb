class Movie < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews
    serialize :genre_ids

    GENRES = [
        {
          "id": 28,
          "name": "Action"
        },
        {
          "id": 12,
          "name": "Adventure"
        },
        {
          "id": 16,
          "name": "Animation"
        },
        {
          "id": 35,
          "name": "Comedy"
        },
        {
          "id": 80,
          "name": "Crime"
        },
        {
          "id": 99,
          "name": "Documentary"
        },
        {
          "id": 18,
          "name": "Drama"
        },
        {
          "id": 10751,
          "name": "Family"
        },
        {
          "id": 14,
          "name": "Fantasy"
        },
        {
          "id": 36,
          "name": "History"
        },
        {
          "id": 27,
          "name": "Horror"
        },
        {
          "id": 10402,
          "name": "Music"
        },
        {
          "id": 9648,
          "name": "Mystery"
        },
        {
          "id": 10749,
          "name": "Romance"
        },
        {
          "id": 878,
          "name": "Science Fiction"
        },
        {
          "id": 10770,
          "name": "TV Movie"
        },
        {
          "id": 53,
          "name": "Thriller"
        },
        {
          "id": 10752,
          "name": "War"
        },
        {
          "id": 37,
          "name": "Western"
        }
      ]

    def self.get_genre_by_id(id)
        GENRES.find { |genre| genre[:id] == id }[:name]
    end

    def self.get_genre_by_name(genre_name)
        GENRES.find { |genre| genre[:name] == genre_name }[:id]
    end

    def has_genre?(genre_name)
        self.genre_ids.include?(Movie.get_genre_by_name(genre_name))
    end

    def get_reviews
        Review.all.select { |review| review.movie_id == self.id }
    end

    def self.get_all_genres
        GENRES.map { |genre| genre[:name] }
    end

    def get_all_by_genre(genres)
        Movie.all.select { |movie| movie.genre == genre }
    end

    def average_user_rating
        if get_reviews.size == 0
            0
        else
            ratings_array = get_reviews.map(&:rating).compact
            sum_of_ratings = ratings_array.reduce(:+)

            (sum_of_ratings / ratings_array.size.to_f).round(2)
        end
    end

    def latest_reviews(n = 5)
        n = self.reviews.size if n > self.reviews.size
        last_n_reviews = self.reviews[-n..-1]

        last_n_reviews.map do |review|
            "#{review.user.name} wrote:
            #{review.comments}
            Rating: #{review.rating} out of 5
            "
        end
    end

    def self.top_5_movies #Return the top 5 user rated movies
        top5 = Movie.all.sort_by(&:average_user_rating).reverse[0..4]
        top5.map do |movie|
            "#{movie.average_user_rating} | #{movie.title} | #{movie.reviews.size} reviews."
        end
    end

    def self.most_reviewed_movie #Return the movie with the most reviews
        result = Movie.all.sort_by { |movie| movie.reviews.size }.last
        "#{result.title} is the most popular movie with #{result.reviews.size} reviews!"
    end

    def self.get_tmdb_movies(pages = 1)
        # seed with N pages w/ 20 movies each from The Movie DB
        current_page = 1
        url = "https://api.themoviedb.org/3/movie/top_rated?api_key=b90e3d41e6ca35ff7dbd3597740c1ca6&language=en-US&page=1"

        pages.times do
            response = RestClient.get(url)
            tmdb_hash = JSON.parse(response)

            tmdb_hash["results"].each do |movie_hash|
                Movie.find_or_create_by(title: movie_hash["title"]) do |movie|
                    movie.release_year = movie_hash["release_date"][0..3].to_i
                    movie.tmdb_rating = movie_hash["vote_average"].to_f / 2
                    movie.tmdb_synopsis = movie_hash["overview"]
                    movie.genre_ids = movie_hash["genre_ids"]
                end
            end

            current_page += 1
            url = "https://api.themoviedb.org/3/movie/top_rated?api_key=b90e3d41e6ca35ff7dbd3597740c1ca6&language=en-US&page=#{current_page.to_s}"
        end
    end
end
