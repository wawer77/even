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
        Friendship.destroy_reverse_friendships(current_user.id, params[:friend_id])
        redirect_back fallback_location: '/'
    end

    def confirm
        friendship = Friendship.find(params[:id])
        friendship.confirm_reverse_friendships
        @friend = User.find(friendship.friend_id)
        @balance = Balance.create(creator_id: current_user.id, partner_id: @friend.id, name: "Default #{current_user.username} - #{@friend.username}", description: "This is a default-created Balance after adding a friend" )
        @balance.users << [current_user, @friend]
        redirect_back fallback_location: '/'
    end
end
