class FriendshipsController < ApplicationController
    before_action :set_friendship, only: [:confirm]
    before_action :pundit_authorize, only: [:destory, :confirm]

    def index
        @sent_invitations = current_user.sent_invitations
        @received_invitations = current_user.received_invitations
        @friends = current_user.friends
        
        @inviting_users = @received_invitations.collect{ |invitation| User.find(invitation.invitor_id) }
        @invited_users = @sent_invitations.collect{ |invitation| User.find(invitation.friend_id) }
    end

    def create
        if Friendship.create_reverse_friendships(current_user.id, params[:friend_id])
            redirect_back fallback_location: '/'
        else
            redirect_back fallback_location: '/', alert: "You can't create the same friendship twice!"
        end
    end

    def destroy
        friend = User.find(params[:friend_id])
        if overall_status_with(friend)[:value] != nil
            redirect_back fallback_location: '/', notice: "You must be even before removing a friend!"
        else
            Friendship.destroy_reverse_friendships(current_user.id, params[:friend_id])
            current_user.balances_with(friend).each(&:destroy)
            redirect_back fallback_location: '/'
        end
    end

    def confirm
        @friendship.confirm_reverse_friendships
        @friend = User.find(@friendship.friend_id)
        @balance = Balance.create(creator_id: @friend.id, partner_id: current_user.id, name: "Default #{@friend.username} - #{current_user.username}", description: "This is a default-created Balance after adding a friend" )
        @balance.users << [current_user, @friend]
        redirect_back fallback_location: '/'
    end

    def set_friendship
        @friendship = Friendship.find(params[:id])
    end

    def pundit_authorize
        authorize @friendship
    end
end
