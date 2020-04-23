class TransactionsController < ApplicationController
    def index
        @issued_transactions = Transaction.where(issuer_id: current_user.id)
        @received_transactions = Transaction.where(receiver_id: current_user.id)
        @transactions = @issued_transactions + @received_transactions
    end
  
    def new
      @transaction = Transaction.new
    end
  
    def create
      @transaction = Transaction.new(transaction_params)
      @current_user_balances = current_user.balances
      @transaction.issuer_id = current_user.id
      @partner_id = @transaction.receiver_id
      @balance_name = @transaction.balance_name
      
      #pry
      @balance = @current_user_balances.joins(:users).where(name: @balance_name, users: { id: @partner_id}).first_or_create do |balance| 
        balance.name = @balance_name
        balance.partner_id = @partner_id
      end
      
      @transaction.balance_id = @balance.id

      #one last issue is first_or_create not passing partner_id to create

      if @transaction.save
        redirect_to @transaction, notice: "Your transaction was created successfully!"
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
