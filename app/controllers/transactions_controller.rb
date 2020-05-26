class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :confirm, :destroy]
    def index
        @transactions = current_user.issued_transactions + current_user.received_transactions
        @transactions_sorted = transactions_sorted(@transactions)
        @output = transactions_output(@transactions_sorted, current_user).reverse.to_enum.with_index(1)
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
      @transaction.creator_id = current_user.id
      @transaction.editor_id = current_user.id
      # if this is run without the 'if' - then in case of balance not chosen - error: no Balance with id: nil instead of save failure
      if @transaction.balance_id
        balance = Balance.find(@transaction.balance_id)
        @transaction.receiver_id = balance.partner_for(current_user).id
      end
      if @transaction.save
        @transaction.balance.change_updated_at_by(current_user)     
        redirect_to balance, notice: "Your transaction was created successfully!"
      else
        render :new
      end
    end
  
    def show
      @output = transactions_output([@transaction], current_user).first
    end
  
    def edit
      authorize @transaction
      if @transaction.receiver == current_user && @transaction.lending_transaction?(current_user)
        @transaction.send_money = 'true'
      elsif  @transaction.receiver == current_user && @transaction.borrowing_transaction?(current_user)
        @transaction.send_money = 'false'
      end
    end
  
    def update
      authorize @transaction
      @new_issuer_id = @transaction.receiver_id
      @new_receiver_id = @transaction.issuer_id
      @transaction.receiver_id = @new_receiver_id
      @transaction.issuer_id = @new_issuer_id
      @transaction.updated_by_id = current_user.id
      if @transaction.update(transaction_params)
        @transaction.balance.change_updated_at_by(current_user)
        redirect_to @transaction, notice: "The transaction was successfully edited."        
      else
        render :edit
      end
    end
  
    def destroy
      authorize @transaction
      @transaction_balance = @transaction.balance
      @transaction.balance.change_updated_at_by(current_user) if @transaction.delete
      redirect_to @transaction_balance, notice: "The transaction was successfully deleted."
    end

    def confirm
      authorize @transaction
      @transaction.balance.change_updated_at_by(current_user) if @transaction.confirmed!
      redirect_back fallback_location: '/', notice: "Transaction confirmed!"
    end
  
    private
  
    def transaction_params
      params.require(:transaction).permit(:description, :value,  :send_money, :balance_id)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end
end
