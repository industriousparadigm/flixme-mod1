class Movie < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :review

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

    def self.top_5_movies
        top5 = Movie.all.sort_by(&:average_user_rating).reverse[0..4]
        top5.map do |movie|
            "#{movie.average_user_rating} | #{movie.title} | #{movie.reviews.size} reviews."
        end
    end

    def self.most_reviewed_movie
        Movie.all.sort_by { |movie| movie.reviews.size }.last
    end
end