require 'rails_helper'

describe 'navigate' do
    before do
        @user = FactoryBot.create(:user)
        @other_user_1 = FactoryBot.create(:user)
        login_as @user
    end

    describe 'index' do       
        it 'shows user' do
            visit user_path(@other_user_1)
            expect(page).to have_content("#{@other_user_1.username}")
        end

        it 'shows send friend request button' do
            login_as @user
            visit user_path(@other_user_1)
            expect(page).to have_link('Send friend request')
        end

        it 'shows send friend request button works' do
            login_as @user
            visit user_path(@other_user_1)
            expect{click_on "Send friend request"}.to change(Friendship, :count).by(2)
        end

    end

    describe 'overall status, balances and transactions with user' do
        before do
            Friendship.create_reverse_friendships(@user.id, @other_user_1.id)
            Friendship.last.confirmed!
            Friendship.second_to_last.confirmed!
            @balance = FactoryBot.create(:balance,
            creator_id: @user.id,
            partner_id: @other_user_1.id
            )
            @balance.users << [@user,@other_user_1]
            @transaction_1= FactoryBot.create(:transaction,
            issuer_id: @user.id,
            receiver_id: @other_user_1.id,
            status: "confirmed",
            balance_id: @balance.id,
            send_money: true,
            )
            @transaction_2= FactoryBot.create(:transaction,
            issuer_id: @user.id,
            receiver_id: @other_user_1.id,
            status: "confirmed",
            balance_id: @balance.id,
            send_money: false,
            )
        end

        it 'has link for new balance' do
            visit user_path(@other_user_1)
            expect(page).to have_link('Create new Balance')
        end

        it 'link for new balance works' do
            visit user_path(@other_user_1)
            click_link('Create new Balance')
            expect(page).to have_current_path("/balances/new?partner_id=#{@other_user_1.id}")
        end

        it 'shows overall status with user borrowing' do
            @transaction_1.destroy
            visit user_path(@other_user_1)
            expect(page).to have_content("Your overall status with the user:You owe: 1.5")
        end

        it 'shows overall status with user lending' do
            @transaction_2.destroy
            visit user_path(@other_user_1)
            expect(page).to have_content("Your overall status with the user:You lended: 1.5")
        end

        it 'shows you are even' do
            visit user_path(@other_user_1)
            expect(page).to have_content("Your overall status with the user:You are even")
        end

        it 'shows balances with user' do
            visit user_path(@other_user_1)
            expect(page).to have_content("Your balances with #{@other_user_1.username}")
            expect(page).to have_content("Balance: #{@balance.name}")
        end

        it 'shows transactions with user' do
            visit user_path(@other_user_1)
            expect(page).to have_content("Your transactions with #{@other_user_1.username}")
            expect(page).to have_link(:href => transaction_path(@transaction_1))
            expect(page).to have_link(:href => transaction_path(@transaction_2))
        end
    end
end


