class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #Redirects users to log in when trying to add post (it's Devise, not Pundit!)
  before_action :authenticate_user!

  #include Pundit
  #rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  #def user_not_authorized
  #  flash[:alert] = "You are not authorized to perform this action."
  #  redirect_to(root_path)
  #end
  
  # TODO - will go to service object later balances & transactions (together, separately?)
  def transactions_output(transactions, user)
    output = []
    transactions.each do |transaction|
      output << {
        transaction: transaction,
        balance: transaction.balance,
        balance_partner: transaction.balance.partner_for(user),
        message: transaction.transaction_message(user),
        description: transaction.description,
        creation_date: transaction.created_at.strftime(" Created on: %-d %B %Y at %k:%M"),
        issuer: transaction.issuer
      }
    end
    output
  end

  def balances_output(balances, user)
    output = []
    balances.each do |balance|
      output << {
        balance: balance,
        partner: balance.partner_for(user),
        creator: User.find(balance.creator_id),
        status: balance_status(balance, user),
        creation_date: balance.created_at
      }
    end
    output
  end

  # TODO - for deletion - methods moved to user model and refactored to cover all transactions / only for specified balances

  # def lending_transactions(balance, user)
  #  partner = balance.partner_for(user)
  #  balance.transactions.where(["issuer_id = ? and #send_money = ?", user.id, 'true']) + balance.#transactions.where(["issuer_id = ? and send_money #= ?", partner, 'false'])
  #end
#
  #def borrowing_transactions(balance,user)
  #  partner = balance.partner_for(user)
  #  balance.transactions.where(["issuer_id = ? and #send_money = ?", user.id, 'false']) + balance.#transactions.where(["issuer_id = ? and send_money #= ?", partner.id, 'true'])
  #end

  #def lended_value(balance, user)
  #  lended_value = 0
  #  lending_transactions(balance, user).each do |#transaction|
  #    lended_value += transaction.value   
  #  end
  #  lended_value
  #end
  #
  #def borrowed_value(balance, user)
  #  borrowed_value = 0
  #  borrowing_transactions(balance, user).each do |#transaction|
  #    borrowed_value += transaction.value   
  #  end
  #  borrowed_value
  #end
  
  # TODO - refactor - to be moved to Balance model? // or service object?
  def balance_status(balance, user)
    lended_value = user.lended_value(balance)
    borrowed_value = user.borrowed_value(balance)
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

  #TODO refactor
  def overall_status_with(user)
    balances = current_user.balances_with(user)
    balance_status(balances, current_user)
  end

end
