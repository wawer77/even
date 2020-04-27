class BalancesController < ApplicationController
  def index
      @output = Array.new
      current_user.balances.each do |balance|
        @output << {
          balance: balance,
          partner: balance.partner_for(current_user)
        }
      end
  end

  def new
    @balance = Balance.new
  end

  def create
    @balance = Balance.new(balance_params)
    @balance.creator_id = current_user.id
    @creator = User.find(@balance.creator_id)
    @partner = User.find(@balance.partner_id)
    #Shouldn't the line above be in the block below?
    if @balance.save
      @balance.users << [@creator, @partner]
      pry
      redirect_to @balance, notice: "Your balance was created successfully!"
    else
      render :new
    end
  end

  def show
    @balance = Balance.find(params[:id])
    @balance_partner = @balance.partner_for(current_user)
    @balance_transactions = @balance.transactions

    #####lending transactions:
    @current_user_lending_transactions = Array.new
    @current_user_lending_transactions = @balance_transactions.where(["issuer_id = ? and send_money = ?", current_user.id, 'true']) + @balance_transactions.where(["issuer_id = ? and send_money = ?", @balance_partner.id, 'false'])

    @current_user_lended_value = 0
    @current_user_lending_transactions.each do |transaction|
      @current_user_lended_value += transaction.value
    end
    
    #####borrowing transactions:
    @current_user_borrowing_transactions = Array.new
    @current_user_borrowing_transactions = @balance_transactions.where(["issuer_id = ? and send_money = ?", current_user.id, 'false']) + @balance_transactions.where(["issuer_id = ? and send_money = ?", @balance_partner.id, 'true'])

    @current_user_borrowed_value = 0
    @current_user_borrowing_transactions.each do |transaction|
      @current_user_borrowed_value += transaction.value
    end

    #####balance satus:
    if @current_user_lended_value > @current_user_borrowed_value
      @balance_status = { status: "lending", value: @current_user_lended_value - @current_user_borrowed_value, message: "You lended: " }
    elsif @current_user_lended_value < @current_user_borrowed_value
      @balance_status = { status: "owing", value: @current_user_borrowed_value - @current_user_lended_value, message: "You owe: " }
    else
      @balance_status = { status: "even", value: nil, message: "You are even!" }
    end
    
    #pry
    
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
