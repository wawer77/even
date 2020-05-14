class FriendshipsController < ApplicationController
    def create
        Friendship.create_reverse_friendships(current_user.id, friend_id)
        redirect_to user_path(User.find(friend_id))
    end

    def destroy
        Friendship.destroy_reverse_friendships(current_user.id, friend_id)
    end
end
