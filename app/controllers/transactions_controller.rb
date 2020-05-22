class TransactionsController < ApplicationController
    def index
        @transactions = (current_user.issued_transactions + current_user.received_transactions).sort_by{|t| t[:created_at]}
        @output = transactions_output(@transactions, current_user)
    end
  
    def new
      @transaction = Transaction.new
      if params[:balance_id]
        @transaction.balance_id = params[:balance_id]
        @transaction.receiver_id = Balance.find(params[:balance_id]).partner_for(current_user).id
      else
      end
    end
  
    def create
      @transaction = Transaction.new(transaction_params)
      @transaction.issuer_id = current_user.id

      if  @transaction.balance_id
        balance = Balance.find(@transaction.balance_id)
        @transaction.receiver_id = balance.partner_for(current_user).id
      else
      end
      if @transaction.save
        redirect_to balance, notice: "Your transaction was created successfully!"
      else
        render :new
      end
    end
  
    def show
      @transaction = Transaction.find(params[:id])
      @output = transactions_output([@transaction], current_user).first
    end
  
    def edit
    end
  
    def update
    end
  
    def destroy
    end

    def confirm
      @transaction = Transaction.find(params[:id])
      authorize @transaction
      @transaction.confirmed!
      redirect_back fallback_location: '/', notice: "Transaction confirmed!"
    end
  
    private
  
    def transaction_params
      params.require(:transaction).permit(:description, :value,  :send_money, :balance_id)
    end   
end
