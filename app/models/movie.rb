class Movie < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :review

    def self.get_tmdb_movies(pages = 1)
    # this populates the database with X pages from The Internet
    # Movie Database, defaulting to 1 page with 20 results
        current_page = 1
        url = "https://api.themoviedb.org/3/movie/top_rated?api_key=b90e3d41e6ca35ff7dbd3597740c1ca6&language=en-US&page=1"

        pages.times do
            response = RestClient.get(url)
            data = JSON.parse(response)
            data["results"].each do |movie_hash|
                Movie.find_or_create_by(
                    title: movie_hash["title"],
                    release_year: movie_hash["release_date"][0..3].to_i,
                    tmdb_rating: movie_hash["vote_average"].to_f / 2
                )
            end
            
            current_page += 1
            url = "https://api.themoviedb.org/3/movie/top_rated?api_key=b90e3d41e6ca35ff7dbd3597740c1ca6&language=en-US&page=#{current_page.to_s}"
        end
    
    end

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

    def self.top_5_movies #Return the top 5 user ratep movies
        top5 = Movie.all.sort_by(&:average_user_rating).reverse[0..4]
        top5.map do |movie|
            "#{movie.average_user_rating} | #{movie.title} | #{movie.reviews.size} reviews."
        end
    end

    def self.most_reviewed_movie #Return the movie with the most reviews
        result = Movie.all.sort_by { |movie| movie.reviews.size }.last
        # "#{result.title} is the most popular movie with #{result.reviews.size} reviews!"
    end
end
