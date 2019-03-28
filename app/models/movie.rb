class Movie < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def get_reviews
        Review.all.select { |review| review.movie_id == self.id }
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
                end
            end

            current_page += 1
            url = "https://api.themoviedb.org/3/movie/top_rated?api_key=b90e3d41e6ca35ff7dbd3597740c1ca6&language=en-US&page=#{current_page.to_s}"
        end
    end
end
