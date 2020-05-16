class Friendship < ApplicationRecord
    enum status: { pending: 0, confirmed: 1 }
    belongs_to :user
    belongs_to :friend, class_name: 'User'

    def self.create_reverse_friendships(user_id, friend_id)
        user_friendship = Friendship.create(user_id: user_id, friend_id: friend_id, status: "pending", invitor_id: user_id)
        friend_friendship = Friendship.create(user_id: friend_id, friend_id: user_id, status: "pending", invitor_id: user_id)
    end

    def self.destroy_reverse_friendships(user_id, friend_id)
        user_friendship = Friendship.find_by(user_id: user_id, friend_id: friend_id)
        friend_friendship = Friendship.find_by(user_id: friend_id, friend_id: user_id)
        user_friendship.destroy
        friend_friendship.destroy
    end

    def confirm_reverse_friendships
        receiver_friendship = Friendship.find_by(user_id: self.user_id, friend_id: self.friend_id)
        invitor_friendship = Friendship.find_by(user_id: self.friend_id, friend_id: self.user_id)
        receiver_friendship.confirmed!
        invitor_friendship.confirmed!
    end
    
    def reverse_friendship
        Friendship.where(user_id: self.friend_id, friend_id: self.user_id)
    end
end
