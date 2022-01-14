require 'rails_helper'

describe 'navigate' do
  before do
    @user = FactoryBot.create(:user)
    login_as @user
  end
  
  describe 'index' do
    before do
      @balance = FactoryBot.create(:balance, creator_id: @user.id)
      @balance.users << [User.find(@balance.creator_id),User.find(@balance.partner_id)] #not sure it should be added here, but it works
    end
    it 'can be reached successfully' do
      visit balances_path
      expect(page.status_code).to eq(200) #with no sign in, this is redirected to login and code is 200 nevertheless
      expect(page).to have_content(/Balances/)
    end

    it 'lists balances created by the user' do
      visit balances_path
      expect(page).to have_link(:href => balance_path(@balance))
    end

    it 'balance link works' do
      visit balances_path
      click_link('show-link')
      expect(page).to have_current_path(balance_path(@balance))
    end
    
    it 'lists balances the user was added to' do
      balance = FactoryBot.create(:balance, partner_id: @user.id)
      balance.users << [User.find(balance.creator_id),User.find(balance.partner_id)] #not sure it should be added here, but it works
      visit balances_path
      expect(page).to have_link(:href => balance_path(balance))
    end

    describe 'Edit Balance button' do
      it 'exists' do
        visit balances_path
        expect(page).to have_link(:href => edit_balance_path(@balance))
      end

      it 'works' do
        visit balances_path
        click_link("Edit balance")
        expect(page).to have_current_path(edit_balance_path(@balance))
      end
    end
      
    describe 'Add Transaction button' do
      it 'exists' do 
        visit balances_path
        expect(page).to have_link(:href => new_transaction_path)
      end

      it 'works' do
        visit balances_path
        click_link("Add transaction")
        expect(page).to have_current_path("/transactions/new?balance_id=#{@balance.id}")
      end
    end

    describe 'Delete button' do
      it 'exists' do 
        visit balances_path
        expect(page).to have_link("Delete balance")
      end

      it 'works' do
        visit balances_path
        expect{click_on "Delete balance"}.to change(Balance, :count).by(-1)
      end
    end
  end

  describe 'creation' do
    it 'has a form that can be reached' do
      visit new_balance_path
      expect(page.status_code).to eq(200)
      expect(page).to have_content(/New balance/)
    end

    describe 'form for balance' do
      before do
        @other_user_1 = FactoryBot.create(:user)
        Friendship.create_reverse_friendships(@user.id, @other_user_1.id)
        Friendship.last.confirmed!
        Friendship.second_to_last.confirmed!
        visit new_balance_path
        fill_in 'balance[name]', :with => "BalanceName"
        fill_in 'balance[description]', :with => "BalanceDescription"
        select @other_user_1.username, :from => 'balance[partner_id]'
      end

      it 'creates balance' do
        expect{click_on "Create"}.to change(Balance, :count).by(1)
      end

      it 'redirects to balance after creation' do
        click_on "Create"
        expect(page).to have_current_path(balance_path(Balance.last))
        expect(page).to have_content(/BalanceName/)
      end
    end
  end
end
