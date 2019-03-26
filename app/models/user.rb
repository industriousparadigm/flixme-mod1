class User < ActiveRecord::Base
    has_many :reviews
    has_many :movies, through: :review

    has_many :friendships
    has_many :friends, through: :friendships
  
    def friendships
        Friendship.all.select do |friendship|
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