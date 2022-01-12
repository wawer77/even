class Friendship < ApplicationRecord
    enum status: { pending: 0, confirmed: 1 }
    validate :invited_is_not_invitor
    belongs_to :user
    belongs_to :friend, class_name: 'User'

    def self.create_reverse_friendships(user_id, friend_id)
        @user_friendship = Friendship.create(user_id: user_id, friend_id: friend_id, invitor_id: user_id)
        @friend_friendship = Friendship.create(user_id: friend_id, friend_id: user_id, invitor_id: user_id)
        return 'true' if @user_friendship.valid?
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

    def invited_is_not_invitor
        if self.user == self.friend
            errors.add(:friend, "cannot be the Invitor at the same time")
        end

    end
end
