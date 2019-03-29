class User < ActiveRecord::Base
    has_many :reviews
    has_many :movies, through: :reviews

    has_and_belongs_to_many :friendships,
      class_name: "User",
      join_table:  :friendships,
      foreign_key: :user_id,
      association_foreign_key: :friend_id

    def review_movie(movie_title, rating, comments = "")
        movie = Movie.find_by title: movie_title
        Review.create(movie: movie, user: self, rating: rating, comments: comments)
    end

    def delete_review(movie_title)
        self.reviews.find { |review| review.movie.title == movie_title }.destroy
    end

    def update_review(movie_title, new_rating, new_comments = "")
        target_id = self.reviews.find { |review| review.movie.title == movie_title }.id
        Review.find(target_id).update_attributes(rating: new_rating, comments: new_comments)
    end

    def format_all_reviews
        self.reviews.map(&:format_review)
    end

    def movies_watched
        self.reviews.map(&:movie)
    end

    def titles_of_movies_watched
        movies_watched.map(&:title)
    end

    def get_friends_names
        self.friends.map(&:name)
    end

    def movies_watched_by_group(friend_list)
        watched = self.movies_watched
        friend_list.each { |friend|  watched.concat(friend.movies_watched) }
        watched.uniq
    end

    def get_friends_by_name_list(friend_names)
        friend_names.map { |name| User.find_by(name: name) }
    end

    def get_random_recommendations(friend_names = [])
        # returns a 5 random movies that neither me nor my friends have seen
        ineligible_movies = movies_watched_by_group(get_friends_by_name_list(friend_names))

        recommendations = []
        count = 0
        while count <= 5
            movie = Movie.find(rand(Movie.first.id..Movie.last.id))
            if !ineligible_movies.include?(movie)
                recommendations << movie
                count += 1
            end
        end

        recommendations.map do |movie|
            "\n#{movie.title} (#{movie.release_year}): #{movie.tmdb_rating}/5\n#{movie.tmdb_synopsis}"
        end
    end

    def get_top_rated_recommendations(friend_names = [])
        # returns a list of top 5 movies that neither me nor my friends have seen

        ineligible_movies = movies_watched_by_group(get_friends_by_name_list(friend_names))

        recommendations = []
        matches_found = 0
        Movie.all.sort_by(&:tmdb_rating).reverse.each do |movie|
            if !ineligible_movies.include?(movie)
                recommendations << movie
                matches_found += 1
            end
            break if matches_found >= 5
        end

        recommendations.map do |movie|
            "\n#{movie.title} (#{movie.release_year}): #{movie.tmdb_rating}/5\n#{movie.tmdb_synopsis}"
        end
    end

    def get_recommendations_by_genre(genre_name, friend_names = [])
        # returns the top 5 movies of a given genre
        ineligible_movies = movies_watched_by_group(get_friends_by_name_list(friend_names))

        recommendations = []
        matches_found = 0
        Movie.all.sort_by(&:tmdb_rating).reverse.each do |movie|
            if !ineligible_movies.include?(movie) && movie.has_genre?(genre_name)
                recommendations << movie
                matches_found += 1
            end
            break if matches_found >= 5
        end

        recommendations.map do |movie|
            "\n#{movie.title} (#{movie.release_year}): #{movie.tmdb_rating}/5\n#{movie.tmdb_synopsis}"
        end

    end

    def self.most_active_reviewer #Return the user with most reviews
        winner = User.all.sort_by do |user|
            user.reviews.size
        end.last

        "#{winner.name} with #{winner.reviews.size} reviews!"
    end

    def add_friend(user)
        Friendship.create(user_id: self.id, friend_id: user.id)
    end

    def add_friend_by_name(name)
        if self.friends.map(&:name).include?(name)
            puts "You are already friends!"
        else
            Friendship.create(user_id: self.id, friend_id: User.find_by(name: name).id)
        end
    end

    def delete_friend(user)
        self.friendships.find do |friendship|
            (friendship.user_id == self.id && friendship.friend_id == user.id) ||
            (friendship.user_id == user.id && friendship.friend_id == self.id)
        end.destroy
    end

    def delete_friend_by_name(name)
        delete_friend(User.find_by(name: name))
    end

    def friendships
        all_friendships = Friendship.all.select do |friendship|
            friendship.user_id == self.id || friendship.friend_id == self.id
        end
    end

    def friends
        friendships.map do |friendship|
            if friendship.user_id == self.id
                User.find(friendship.friend_id)
            elsif friendship.friend_id == self.id
                User.find(friendship.user_id)
            end
        end.uniq
    end
end
