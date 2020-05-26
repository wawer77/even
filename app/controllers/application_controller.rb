class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #Redirects users to log in when trying to add post (it's Devise, not Pundit!)
  before_action :authenticate_user!

  # Defines what to do in case of unathorized action
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_back fallback_location: '/', notice: "You are not authorized to perform this action!"
  end
  
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
        edition_date: transaction.updated_at.strftime(" Updated on: %-d %B %Y at %k:%M"),
        creator: transaction.creator,
        editor: transaction.editor
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
        status: balance_status(balance, user),
        creation_date: balance.created_at.strftime(" Created on: %-d %B %Y at %k:%M"),
        edition_date: balance.updated_at.strftime(" Edited on: %-d %B %Y at %k:%M"),
        creator: balance.creator,
        editor: balance.editor
      }
    end
    output
  end

  def transactions_sorted(transactions)
    output = []
    pending = []
    confirmed = []
    transactions.sort_by{|t| t[:updated_at]}.each do |transaction|
      if transaction.status == 'pending'
        pending << transaction
      else
        confirmed << transaction
      end
    end
    pending.reverse!
    confirmed.reverse!
    output = pending + confirmed
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
