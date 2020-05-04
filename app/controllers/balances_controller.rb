class BalancesController < ApplicationController
  def index
      @balances = current_user.balances.reverse_each
      @output = balances_output(@balances, current_user)
  end

  def new
    @balance = Balance.new
  end

  def create
    @balance = Balance.new(balance_params)
    @balance.creator_id = current_user.id
    @creator = User.find(@balance.creator_id)
    @partner = User.find(@balance.partner_id)
    @balance.users << [@creator, @partner]
    if @balance.save
      redirect_to @balance, notice: "Your balance was created successfully!"
    else
      render :new
    end
  end


  def show
    @balance = Balance.find(params[:id])
    @balance_partner = @balance.partner_for(current_user)
    @balance_status = balance_status(@balance, current_user)
    @transactions = @balance.transactions
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  
  def balance_params
    params.require(:balance).permit(:name, :description, :partner_id, :creator_id)
  end
end
