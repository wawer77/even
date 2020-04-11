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
      @transaction = transaction.new(transaction_params)
      @transaction.issuer_id = current_user.id
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
      params.require(:transaction).permit(:description, :value , :issuer_id, :receiver_id, :send_money, :balance_id)
    end
  
 end
