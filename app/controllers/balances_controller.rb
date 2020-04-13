class BalancesController < ApplicationController
    def index
        @balances = current_user.balances
    end
  
    def new
      @balance = Balance.new
    end
  
    def create
      @balance = Balance.new(balance_params)
      @partner = User.where(id: @balance.partner_id)
      @balance.users << [current_user, @partner]
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
