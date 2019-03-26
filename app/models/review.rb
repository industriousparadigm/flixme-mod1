class Review < ActiveRecord::Base
    belongs_to :movie
    belongs_to :user

    def self.top_5_movies
        #
    end
    
end
    
