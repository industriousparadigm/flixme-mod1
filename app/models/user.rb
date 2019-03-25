class User < ActiveRecord::Base
    has_many :reviews
    has_many :movies, through: :review
    has_many :friends, foreign_key: :friend_a, class_name: 'Friendship'
    has_many :friends, foreign_key: :friend_b, class_name: 'Friendship'

    def add_friend(user)
        Friendship.new(friend_a: self.id, friend_b: user.id)
        puts "BFFs 4evr!!!"
    end
end