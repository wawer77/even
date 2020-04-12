class BalancesController < ApplicationController
    def index
        #@issued_balances = Balance.where(issuer_id: current_user.id)
        #@received_balances = Balance.where(receiver_id: current_user.id)
        #@balances = @issued_balances + @received_balances
    end
  
    def new
      @balance = Balance.new
    end
  
    def create
      @balance = Balance.new(balance_params)
      #@balance.issuer_id = current_user.id
      if @balance.save
        redirect_to @balance, notice: "Your balance was created successfully!"
      else
        render :new
      end
    end
  
    def show
      #@balance = Balance.find(params[:id])
    end
  
    def edit
    end
  
    def update
    end
  
    def destroy
    end
  
    private
  
    def balance_params
      params.require(:balance).permit(:name, :description)
    end
end
