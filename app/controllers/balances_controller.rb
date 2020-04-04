class BalancesController < ApplicationController

  def index
      @own_balances = Balance.where(owner_id: current_user.id)
      @added_to_balances = Balance.where(added_user_id: current_user.id)
      @balances = @own_balances + @added_to_balances
  end

  def new
    @balance = Balance.new
  end

  def create
    @balance = Balance.new(balance_params)
    @balance.owner_id = current_user.id
    if @balance.save
      redirect_to @balance, notice: "Your balance was created successfully"
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
    params.require(:balance).permit(:name, :value , :owner_id, :added_user_id)
  end

end
