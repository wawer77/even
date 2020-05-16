class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @transactions = transactions_with(@user, current_user)
        @transactions_output = transactions_output(@transactions, current_user)
        @balances = @transactions.collect(&:balance).uniq.sort_by{|t| t[:created_at]}.reverse
        @balances_output = balances_output(@balances, current_user)
    end

    private  
    # TODO - into transactions model? and rename to _between
    def transactions_with(user, partner)
        user.transactions.where(issuer_id: partner.id) + user.transactions.where(receiver_id: partner.id)
    end
end
