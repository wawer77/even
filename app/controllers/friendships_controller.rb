class FriendshipsController < ApplicationController
    def index
        @sent_invitations = current_user.sent_invitations
        @received_invitations = current_user.received_invitations
        @friends = current_user.friends
        
        @inviting_users = @received_invitations.collect{ |invitation| User.find(invitation.invitor_id) }
        @invited_users = @sent_invitations.collect{ |invitation| User.find(invitation.friend_id) }
    end

    def create
        Friendship.create_reverse_friendships(current_user.id, params[:friend_id])
        redirect_back fallback_location: '/'
    end

    def destroy
        friend = User.find(params[:friend_id])
        if overall_status_with(friend)[:value] != nil
            redirect_back fallback_location: '/', notice: "You must be even before removing a friend!"
        else
            Friendship.destroy_reverse_friendships(current_user.id, params[:friend_id])
            redirect_back fallback_location: '/'
        end
    end

    def confirm
        friendship = Friendship.find(params[:id])
        friendship.confirm_reverse_friendships
        @friend = User.find(friendship.friend_id)
        @balance = Balance.create(creator_id: @friend.id, partner_id: current_user.id, name: "Default #{@friend.username} - #{current_user.username}", description: "This is a default-created Balance after adding a friend" )
        @balance.users << [current_user, @friend]
        redirect_back fallback_location: '/'
    end
end
