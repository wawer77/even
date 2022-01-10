require 'rails_helper'

describe 'navigate' do
  before do
    user = FactoryBot.create(:user)
    login_as user
  end
  
  describe 'index' do
    it 'can be reached successfully' do
      visit balances_path
      expect(page.status_code).to eq(200) #with no sign in, this is redirected to login and code is 200 nevertheless
      expect(page).to have_content(/Balances/)
    end
  end

  describe 'creation' do
    it 'has a form that can be reached' do
      visit new_balance_path
      expect(page.status_code).to eq(200)
      expect(page).to have_content(/New balance/)
    end
  end
end