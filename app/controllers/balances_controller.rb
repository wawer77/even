class BalancesController < ApplicationController
  def index
      @balances = current_user.balances.reverse_each
      @output = balances_output(@balances, current_user)
  end

  def new
    @balance = Balance.new
    @balance.partner_id = params[:partner_id]
  end
  
  def create
    @balance = Balance.new(balance_params)
    if current_user.friends_with?(User.find(balance_params[:partner_id]))
      @balance.creator_id = current_user.id
      if @balance.save
        @balance.users << [current_user, User.find(@balance.partner_id)]
        redirect_to @balance, notice: "Your balance was created successfully!"
      else
        render :new            
      end
    else
      redirect_back fallback_location: '/', notice: "You can create balances with friends only."
    end
  end


  def show
    @balance = Balance.find(params[:id])
    @balance_partner = @balance.partner_for(current_user)
    @balance_status = balance_status(@balance, current_user)
    @transactions = @balance.transactions
    @transactions_output = transactions_output(@transactions, current_user)
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
