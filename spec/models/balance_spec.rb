require 'rails_helper'

RSpec.describe Balance, type: :model do
  before do
    @balance = FactoryBot.create(:balance)
    @balance.users << [User.find(@balance.creator_id),User.find(@balance.partner_id)] #not sure it should be added here, but it works
  end

  describe 'creation' do
    it 'can be created' do
      expect(@balance).to be_valid
    end
  end

  describe 'validations' do
    it 'cannot be created without name' do
      @balance.name = nil
      expect(@balance).to_not be_valid
    end

    it 'can be created without description' do
      @balance.description = nil
      expect(@balance).to be_valid
    end

    it 'cannot be created without 2 different users' do
      @two_users = [@balance.users.first,@balance.users.first]
      @balance.users.replace(@two_users)
      expect(@balance).to_not be_valid
    end
  end

  describe 'method' do
    
    it 'partner_for works' do
      expect(@balance.partner_for(@balance.creator).id).to eq(@balance.partner_id)
    end

    it 'change_updated_at_by works' do
      @balance.change_updated_at_by(User.find(@balance.partner_id))
      expect(@balance.editor_id).to eq(@balance.partner_id)
    end

    describe 'even ' do
      it 'works when creator borrows' do
        transaction = FactoryBot.create(:transaction,
        issuer_id: @balance.creator_id,
        receiver_id: @balance.partner_id,
        balance_id: @balance.id,
        send_money: false,
        status: "confirmed"
        )
       expect(@balance.even?).to be false
      end

      it 'works when creator lends' do
        transaction = FactoryBot.create(:transaction,
        issuer_id: @balance.creator_id,
        receiver_id: @balance.partner_id,
        balance_id: @balance.id,
        send_money: true,
        status: "confirmed"
        )
       expect(@balance.even?).to be false
      end

      it 'works false when more than 2 transactions are present' do
        transaction_1 = FactoryBot.create(:transaction,
        issuer_id: @balance.creator_id,
        receiver_id: @balance.partner_id,
        balance_id: @balance.id,
        send_money: true,
        status: "confirmed"
        )
        transaction_2 = FactoryBot.create(:transaction,
        issuer_id: @balance.creator_id,
        receiver_id: @balance.partner_id,
        balance_id: @balance.id,
        send_money: false,
        value: 5,
        status: "confirmed"
        )
       expect(@balance.even?).to be false
      end

      it 'works true when more than 2 transactions are present' do
        transaction_1 = FactoryBot.create(:transaction,
        issuer_id: @balance.creator_id,
        receiver_id: @balance.partner_id,
        balance_id: @balance.id,
        send_money: true,
        value: 5,
        status: "confirmed"
        )
        transaction_2 = FactoryBot.create(:transaction,
        issuer_id: @balance.creator_id,
        receiver_id: @balance.partner_id,
        balance_id: @balance.id,
        send_money: false,
        value: 5,
        status: "confirmed"
        )
       expect(@balance.even?).to be true
      end

    end
  end
end
