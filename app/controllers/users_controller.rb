class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @sorted_transactions = transactions_sorted(current_user.transactions_with(@user))
        @transactions_output = transactions_output(@sorted_transactions, current_user).reverse.to_enum.with_index(1)
        @balances_output = balances_output(current_user.balances_with(@user), current_user)
        @overall_status = overall_status_with(@user)   
    end
end
