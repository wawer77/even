require 'rails_helper'

describe 'navigate' do
  before do
    @user = FactoryBot.create(:user)
    login_as @user
  end

  describe 'index' do
    it 'can be reached successfully' do
      visit transactions_path
      expect(page).to have_content(/Your Transactions/)
    end

    it 'shows transactions the user is issuer for' do
      transaction = FactoryBot.create(:transaction, issuer_id: @user.id)
      balance = transaction.balance
      balance.users << [User.find(transaction.issuer_id),User.find(transaction.receiver_id)] #not sure it should be added here, but it works
      visit transactions_path
      expect(page).to have_link(:href => transaction_path(transaction))
    end

    it 'shows transactions the user is receiver for' do
      transaction = FactoryBot.create(:transaction, receiver_id: @user.id)
      balance = transaction.balance
      balance.users << [User.find(transaction.issuer_id),User.find(transaction.receiver_id)] #not sure it should be added here, but it works
      visit transactions_path
      expect(page).to have_link(:href => transaction_path(transaction))
    end
  end

  describe 'actions' do
    describe 'transaction created or edited by current user' do
      before do
        @transaction = FactoryBot.create(:transaction, issuer_id: @user.id)
        @balance = @transaction.balance
        @balance.users << [User.find(@transaction.issuer_id),User.find(@transaction.receiver_id)] #not sure it should be added here, but it works
        visit transactions_path
      end

      describe 'before editing' do
        it 'can be deleted by current user' do
          expect { click_link 'Delete transaction' }.to change(Transaction, :count).by(-1)
        end

        it 'redirects to Balance page after deletion' do
          click_link 'Delete transaction'
          expect(page).to have_current_path(balance_path(@balance))
        end

        it 'has a button to be edited by current user' do
          click_link 'Edit transaction'
          expect(page).to have_current_path(edit_transaction_path(@transaction))
        end
        
        it 'cannot be confirmed by current user' do
          expect(page).to_not have_link("Confirm transaction", href: '/transaction/@transaction.id/confirm')
        end
      end

      describe 'after editing' do
        before do
          visit edit_transaction_path(@transaction)
          fill_in 'transaction[value]', with: 100
          click_on "Send"
        end

        it 'can be edited by current user' do
          expect(Transaction.find(@transaction.id).value).to eq(100)
        end

        it 'cannot be confirmed by current user after editing by current user' do
          visit transactions_path
          expect(page).to_not have_link(edit_transaction_path(@transaction))
        end

        it 'can be edited by current user after editing by current user' do
          visit transactions_path
          click_link 'Edit transaction'
          expect(page).to have_current_path(edit_transaction_path(@transaction))
        end
      end
    end
    #Thought about going farther in the loop, but now the following section takes over, when the current user becomes the "different one" and the behvaiour on the other side is testes below.

    describe 'transaction created or edited by different user' do
      before do
        @transaction = FactoryBot.create(:transaction, receiver_id: @user.id)
        @balance = @transaction.balance
        @balance.users << [User.find(@transaction.issuer_id),User.find(@transaction.receiver_id)] #not sure it should be added here, but it works
        visit transactions_path
      end

      it 'can be confirmed by current user' do
        click_link 'Confirm transaction'
        expect(Transaction.find(@transaction.id)).to have_attributes(:status => "confirmed") #need to "load" the transaction again as @transaction is var loaded before confirmation
      end

      it 'has a button to be edited by current user' do
        click_link 'Edit transaction'
        expect(page).to have_current_path(edit_transaction_path(@transaction))
      end

      it 'cannot be deleted by current user' do
        expect(page).to_not have_link("Delete transaction")
      end

      it 'can be edited by current user' do
        visit edit_transaction_path(@transaction)
        fill_in 'transaction[value]', with: 100
        click_on "Send"
        expect(Transaction.find(@transaction.id).value).to eq(100)
      end
    end
  end
end
