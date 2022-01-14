require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end

  describe 'creation' do
    it 'can be created' do
      expect(@user).to be_valid
    end
  end

  describe 'validations' do
    it 'cannot be created without e-mail' do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it 'cannot be created without first name' do
      @user.first_name = nil
      expect(@user).to_not be_valid
    end

    it 'cannot be created without last_name' do
      @user.last_name = nil
      expect(@user).to_not be_valid
    end

    it 'cannot be created without username' do
      @user.username = nil
      expect(@user).to_not be_valid
    end
  end

  describe 'methods' do
    describe 'for transactions' do
      before do
        @other_user_1 = FactoryBot.create(:user)
        @other_user_2 = FactoryBot.create(:user)
        @transaction_1 = FactoryBot.create(:transaction,
        issuer_id: @user.id,
        receiver_id: @other_user_1.id,
        status: "confirmed"
        )
        @transaction_2 = FactoryBot.create(:transaction,
        issuer_id: @user.id,
        receiver_id: @other_user_2.id,
        status: "confirmed"
        )
      end

      it 'transaction works' do
        expect(@user.transactions).to eq([@transaction_1, @transaction_2])
      end

      it 'transaction_with works' do
        expect(@user.transactions_with(@other_user_1)).to eq([@transaction_1])
      end

      describe 'lending/borrowing transactions and values' do
        before do
          @transaction_1_2 = FactoryBot.create(:transaction,
          issuer_id: @user.id,
          receiver_id: @other_user_1.id,
          status: "confirmed",
          balance_id: @transaction_1.balance.id
          )
        end
      
        it 'lending_transactions works if empty' do
          expect(@user.lending_transactions([@transaction_1.balance, @transaction_2.balance])).to be_empty
        end

        it 'lending_transactions works if not empty' do
          expect(@other_user_1.lending_transactions(@transaction_1.balance)).to eq([@transaction_1, @transaction_1_2])
        end

        it 'borrowing_transactions works if empty' do
          expect(@other_user_1.borrowing_transactions(@transaction_1.balance)).to be_empty
        end

        it 'borrowing_transactions works if not empty' do
          expect(@user.borrowing_transactions([@transaction_1.balance, @transaction_2.balance])).to eq([@transaction_1, @transaction_2, @transaction_1_2])
        end

        it 'lended_value works if 0' do
          expect(@user.lended_value([@transaction_1.balance, @transaction_2.balance])).to eq( 0 )
        end

        it 'lended_value works if not 0' do
          expect(@other_user_1.lended_value(@transaction_1.balance)).to eq( 3 )
        end

        it 'borrowed_value works if 0' do
          expect(@other_user_1.borrowed_value(@transaction_1.balance)).to eq( 0 )
        end

        it 'borrowed_value works if not 0' do
          expect(@user.borrowed_value(@transaction_1.balance)).to eq( 3 )
        end

        it 'borrowed_value works if not 0 for multiple balances' do
          expect(@user.borrowed_value([@transaction_1.balance, @transaction_2.balance])).to eq( 4.5 )
        end
      end
    end

    it 'balances_with works' do
      @other_user_1 = FactoryBot.create(:user)
      @other_user_2 = FactoryBot.create(:user)
      @balance_1 = FactoryBot.create(:balance,
      creator_id: @user.id,
      partner_id: @other_user_1.id,
      )
      @balance_1.users << [@user, @other_user_1] #not sure it should be added here, but it works
      @balance_2 = FactoryBot.create(:balance,
      creator_id: @user.id,
      partner_id: @other_user_1.id,
      )
      @balance_2.users << [@user, @other_user_1] #not sure it should be added here, but it works
      @balance_3 = FactoryBot.create(:balance,
      creator_id: @user.id,
      partner_id: @other_user_2.id,
      )
      @balance_3.users << [@user, @other_user_2] #not sure it should be added here, but it works
      expect(@user.balances_with(@other_user_1)).to eq([@balance_1, @balance_2]) 
    end

    describe 'for friendships' do
      before do
        @other_user_1 = FactoryBot.create(:user)
        Friendship.create_reverse_friendships(@user.id, @other_user_1.id)
        #Creation here and confirmed! below should be included in Factory, which means the factory needs to be rebuilt or the model itself? 
      end
      describe 'confirmed' do
        before do
          Friendship.last.confirmed!
          Friendship.second_to_last.confirmed!
        end
      
        it 'friends_with? works' do
          expect(@user.friends_with?(@other_user_1)).to be true
          expect(@other_user_1.friends_with?(@user)).to be true
        end

        it 'friendship_with works' do
          expect(@user.friendship_with(@other_user_1).first).to eq(Friendship.second_to_last)
          expect(@other_user_1.friendship_with(@user).first).to eq(Friendship.last)
        end
      end
    end
  end
end
