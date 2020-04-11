class TransactionsController < ApplicationController
    def index
        #@own_transactions = transaction.where(owner_id: current_user.id)
        #@added_to_transactions = transaction.where(added_user_id: current_user.id)
        #@transactions = @own_transactions + @added_to_transactions
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
      @transaction = transaction.find(params[:id])
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
