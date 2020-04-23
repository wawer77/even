class BalancesController < ApplicationController
    def index
        @output = Array.new
        current_user.balances.each do |balance|
          @output << {
            balance: balance,
            partner: balance.users.where.not(id: current_user.id).first
          }
        end
    end
  
    def new
      @balance = Balance.new
    end
  
    def create
      @balance = Balance.new(balance_params)
      @partner = User.find(@balance.partner_id)
      @balance.users << [current_user, @partner]
      #Shouldn't the line above be in the block below?
      if @balance.save
        redirect_to @balance, notice: "Your balance was created successfully!"
      else
        render :new
      end
    end
  
    def show
      @balance = Balance.find(params[:id])
    end
  
    def edit
    end
  
    def update
    end
  
    def destroy
    end
  
    private
  
    def balance_params
      params.require(:balance).permit(:name, :description, :partner_id)
    end
end
