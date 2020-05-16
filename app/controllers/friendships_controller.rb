class FriendshipsController < ApplicationController
    def create
        Friendship.create_reverse_friendships(current_user.id, params[:friend_id])
        redirect_back fallback_location: '/'
    end

    def destroy
        Friendship.destroy_reverse_friendships(current_user.id, params[:friend_id])
        redirect_back fallback_location: '/'
    end

    def confirm
        friendship = Friendship.find(params[:id])
        friendship.confirm_reverse_friendships
        redirect_back fallback_location: '/'
    end
end
