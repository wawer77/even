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
  end
end
