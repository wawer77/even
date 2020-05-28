class BalancesController < ApplicationController
  before_action :set_balance, only: [:show, :edit, :update, :destroy]
  before_action :pundit_authorize, only: [:show, :edit, :update, :destroy]

  def index
      @balances = current_user.balances.reverse
      @output = balances_output(@balances, current_user)
  end

  def new
    @balance = Balance.new
    @balance.partner_id = params[:partner_id]
  end
  
  def create
    @balance = Balance.new(balance_params)
    @balance.creator_id = current_user.id
    @balance.editor_id = current_user.id
    if @balance.valid?
      if current_user.friends_with?(User.find(@balance.partner_id))
        @balance.save
        @balance.users << [current_user, User.find(@balance.partner_id)]
        redirect_to @balance, notice: "Your balance was created successfully!"
      else
        redirect_back fallback_location: '/', notice: "You can create balances with friends only." 
      end
    else
      render :new
    end
  end

  def show
    @balance_partner = @balance.partner_for(current_user)
    @balance_status = balance_status(@balance, current_user)
    @transactions = transactions_sorted(@balance.transactions)
    @transactions_output = transactions_output(@transactions, current_user).reverse.to_enum.with_index(1)
  end

  def edit
    @balance.partner_id = @balance.partner_for(current_user).id
  end

  def update
    #partner_id doesn't need to be passed here, as it already exists and validation is turned off, but when .update fails, render :edit renders without it and it's ugly
    @balance.partner_id = @balance.partner_for(current_user).id
    @balance.editor_id = current_user.id
    if @balance.update(balance_params)
      redirect_to @balance, notice: "The balance was successfully edited."
    else
      render :edit
    end
  end

  def destroy
    if @balance.even?
      @balance.delete
      redirect_to '/balances', notice: "The balance was deleted."
    else
      redirect_back fallback_location: '/balances', alert: "You can't delete uneven Balance!"
    end
  end

  private
  
  def balance_params
    params.require(:balance).permit(:name, :description, :partner_id)
  end

  def set_balance
    @balance = Balance.find(params[:id])
  end

  def pundit_authorize
    authorize @balance
  end
end
