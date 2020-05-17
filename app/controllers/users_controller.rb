class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @transactions = transactions_with(@user)
        @transactions_output = transactions_output(@transactions, current_user)
        @balances = @transactions.collect(&:balance).uniq.sort_by{|t| t[:created_at]}.reverse
        @balances_output = balances_output(@balances, current_user)
        @overall_status = balance_status(@balances, current_user)   
    end

    private  
end
