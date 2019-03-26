class User < ActiveRecord::Base
    has_many :reviews
    has_many :movies, through: :review

    has_and_belongs_to_many :friendships,
      class_name: "User",
      join_table:  :friendships,
      foreign_key: :user_id,
      association_foreign_key: :friend_user_id

    def review_movie(movie_title, rating, comments = "")
      movie = Movie.find_by title: movie_title
          Review.create(movie: movie, user: self, rating: rating, comments: comments)
    end

    def self.most_active_reviewer #Return the user with most reviews
        User.all.sort_by do |user|
            user.reviews.size
        end.last
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
        #
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
