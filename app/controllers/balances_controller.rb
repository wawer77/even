class BalancesController < ApplicationController
    def index
        @current_user_all_balances = current_user.balances
        @balance_partners = []
        @current_user_all_balances.each do |balance|
          partner = balance.users.where.not(id: current_user.id).first
          @balance_partners << partner
        end
        
        i = 0
        @response = []
        loop do
          @response << {
            balance: @current_user_all_balances[i],
            partner: @balance_partners[i]
          }
          i += 1
          break if @current_user_all_balances[i] == nil
        end
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
