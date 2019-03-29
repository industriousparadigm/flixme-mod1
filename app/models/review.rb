class Review < ActiveRecord::Base
    belongs_to :movie
    belongs_to :user
end
    
def format_review
    ["","#{self.movie.title} (#{self.movie.release_year})" , "Rated #{i.rating}/5 stars", i.comments]
end

# User.find_by(name: temp_target_friend).reviews.map{|i| ["",Movie.find(i.movie_id).title, "With the rating of: #{i.rating}", i.comments]}