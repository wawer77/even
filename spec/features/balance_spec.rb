require 'rails_helper'

describe 'navigate' do
  before do
    @user = FactoryBot.create(:user)
    login_as @user
  end
  
  describe 'index' do
    it 'can be reached successfully' do
      visit balances_path
      expect(page.status_code).to eq(200) #with no sign in, this is redirected to login and code is 200 nevertheless
      expect(page).to have_content(/Balances/)
    end

    it 'lists balances created by the user' do
      balance = FactoryBot.create(:balance, creator_id: @user.id)
      balance.users << [User.find(balance.creator_id),User.find(balance.partner_id)] #not sure it should be added here, but it works
      visit balances_path
      expect(page).to have_link(:href => balance_path(balance))
    end
    
    it 'lists balances the user was added to' do
      balance = FactoryBot.create(:balance, partner_id: @user.id)
      balance.users << [User.find(balance.creator_id),User.find(balance.partner_id)] #not sure it should be added here, but it works
      visit balances_path
      expect(page).to have_link(:href => balance_path(balance))
    end
  end

  describe 'creation' do
    it 'has a form that can be reached' do
      visit new_balance_path
      expect(page.status_code).to eq(200)
      expect(page).to have_content(/New balance/)
    end

    # Add test for filling the form and creating the balance
  end
end