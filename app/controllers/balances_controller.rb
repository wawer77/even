class BalancesController < ApplicationController
  def index
      @output = Array.new
      current_user.balances.each do |balance|
        @output << {
          balance: balance,
          partner: balance.partner_for(current_user),
          status: balance_status(balance, current_user)
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

  def lending_transactions(balance, user)
    partner = balance.partner_for(user)
    balance.transactions.where(["issuer_id = ? and send_money = ?", user.id, 'true']) + balance.transactions.where(["issuer_id = ? and send_money = ?", partner, 'false'])
  end

  def borrowing_transactions(balance,user)
    partner = balance.partner_for(user)
    balance.transactions.where(["issuer_id = ? and send_money = ?", user.id, 'false']) + balance.transactions.where(["issuer_id = ? and send_money = ?", partner.id, 'true'])
  end

  def lended_value(balance, user)
    lended_value = 0
    lending_transactions(balance, user).each do |transaction|
      lended_value += transaction.value   
    end
    lended_value
  end
  
  def borrowed_value(balance, user)
    borrowed_value = 0
    borrowing_transactions(balance, user).each do |transaction|
      borrowed_value += transaction.value   
    end
    borrowed_value
  end

  def balance_status(balance, user)
    lended_value = lended_value(balance, user)
    borrowed_value = borrowed_value(balance, user)
    if lended_value > borrowed_value
      balance_status = { 
        status: "lending",
        value: lended_value - borrowed_value, 
        message: "You lended: " 
      }
    elsif lended_value < borrowed_value
      balance_status = { 
        status: "owing", 
        value: borrowed_value - lended_value,
        message: "You owe: " 
      }
    else
      balance_status = { 
        status: "even", 
        value: nil, 
        message: "You are even!" 
    }
    end
  end
end
