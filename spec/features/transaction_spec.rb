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

  describe 'creation' do
    it 'has a form that can be reached' do
      visit new_transaction_path
      expect(page.status_code).to eq(200)
      expect(page).to have_content(/New transaction/)
    end

    describe 'form for' do
      before do
        @other_user_1 = FactoryBot.create(:user)
        Friendship.create_reverse_friendships(@user.id, @other_user_1.id)
        Friendship.last.confirmed!
        Friendship.second_to_last.confirmed!
        @balance = FactoryBot.create(:balance,
        creator_id: @user.id,
        partner_id: @other_user_1.id
        )
        @balance.users << [@user,@other_user_1]
        visit new_transaction_path
        fill_in 'transaction[description]', :with => "TransactionDescription"
        select @balance.name, :from => 'transaction[balance_id]'
        fill_in 'transaction[value]', :with => 100
      end

      describe 'lending transaction' do
        before do
          page.choose('transaction[send_money]', id: 'transaction_send_money_true')
        end

        it 'creates transaction' do
          expect{click_on "Send"}.to change(Transaction, :count).by(1)
          expect(Transaction.last.send_money).to be true
        end
  
        it 'redirects to balance for transaction after creation' do
          click_on "Send"
          expect(page).to have_current_path(balance_path(@balance))
        end

        it 'transaction is listed on the balance page' do
          click_on "Send"
          expect(page).to have_link(:href => transaction_path(Transaction.last))
        end

        it 'shows you lended the money' do
          click_on "Send"
          expect(page).to have_content(/You lended: 100/)
        end
      end

      describe 'borrowing transaction' do
        before do
          page.choose('transaction[send_money]', id: 'transaction_send_money_false', allow_label_click: true)
        end

        it 'creates transaction' do
          page.choose('I borrow the money')
          expect{click_on "Send"}.to change(Transaction, :count).by(1)
          expect(Transaction.last.send_money).to be false
        end
  
        it 'redirects to balance for transaction after creation' do
          click_on "Send"
          expect(page).to have_current_path(balance_path(@balance))
        end

        it 'transaction is listed on the balance page' do
          click_on "Send"
          expect(page).to have_link(:href => transaction_path(Transaction.last))
        end

        it 'shows you borrowed the money' do
          click_on "Send"
          expect(page).to have_content(/You borrowed: 100/)
        end
      end
    end
  end

  describe 'show' do
    it 'transaction page can be reached' do
      transaction = FactoryBot.create(:transaction, issuer_id: @user.id)
      balance = transaction.balance
      balance.users << [User.find(transaction.issuer_id),User.find(transaction.receiver_id)] #not sure it should be added here, but it works
      visit transaction_path(transaction)
      expect(page).to have_content("Balance: #{balance.name} with user #{User.find(transaction.receiver_id).username}")
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
