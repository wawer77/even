class TransactionsController < ApplicationController
    def index
        @transactions = (current_user.issued_transactions + current_user.received_transactions).sort_by{|t| t[:created_at]}
        @output = []
        @transactions.each do |transaction|
          @output << {
            transaction: transaction,
            balance: transaction.balance,
            balance_partner: transaction.balance.partner_for(current_user),
            message: transaction.transaction_message(current_user),
            description: transaction.description,
            creation_date: transaction.created_at.strftime(" Created on: %-d %B %Y at %k:%M"),
            issuer: transaction.issuer
          }
        end
    end
  
    def new
      @transaction = Transaction.new
    end
  
    def create
      @transaction = Transaction.new(transaction_params)
      @transaction.issuer_id = current_user.id
      @partner = User.find(@transaction.receiver_id)
      @users = [current_user, @partner]
      @balance_name = @transaction.balance_name
      @current_user_balances = current_user.balances
      
      @balance = @current_user_balances.joins(:users).where(name: @balance_name, users: { id: @partner.id}).first_or_create do |balance| 
        @users.each do |user|  
          balance.name = @balance_name
          balance.partner_id = @partner.id
          balance.creator_id = current_user.id
          balance.users = [user]
        end
      end
      
      @transaction.balance_id = @balance.id
      if @transaction.save
        redirect_to @balance, notice: "Your transaction was created successfully!"
      else
        render :new
      end
    end
  
    def show
      @transaction = Transaction.find(params[:id])
    end
  
    def edit
    end
  
    def update
    end
  
    def destroy
    end
  
    private
  
    def transaction_params
      params.require(:transaction).permit(:description, :value , :issuer_id, :receiver_id, :send_money, :balance_name)
    end
  
 end
