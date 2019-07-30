class BalancesController < ApplicationController

  def index
  end

  def new
    @balance = Balance.new
  end

  def create
    @balance = Balance.new(balance_params)
    #balancer_1_id = current_user
    @balancer_1_id = 1
    @balancer_2_id = 2
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
    params.require(:balance).permit(:balancer_1_id, :balancer_2_id, :balancer_1_debt, :balancer_2_debt)
  end

end
