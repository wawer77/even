require 'rails_helper'

RSpec.describe Transaction, type: :model do
  before do
    @transaction = FactoryBot.create(:transaction)
  end

  describe "creation" do
    it "can be created" do
      expect(@transaction).to be_valid
    end
  end

  describe "validations" do
    it "can be created without description" do
      @transaction.description = nil
      expect(@transaction).to be_valid
    end

    it "cannot be created without value" do
      @transaction.value = nil
      expect(@transaction).to_not be_valid
    end

    it "has to be assigned to a balance" do
      @transaction.balance = nil
      expect(@transaction).to_not be_valid
    end

    it "has to send or receive money" do
      @transaction.send_money = nil
      expect(@transaction).to_not be_valid
    end

    it "has to have a different issuer and receiver" do
      @transaction.issuer_id = @transaction.receiver_id
      expect(@transaction).to_not be_valid
    end
  end

  describe "method" do
    before do
      @issuer = User.find(@transaction.issuer_id)
      @receiver = User.find(@transaction.receiver_id)
    end

    it "users works" do
      expect(@transaction.users).to eq([@issuer, @receiver])
    end

    it "partner_for works" do
      expect(@transaction.partner_for(@issuer)).to eq(@receiver)
      expect(@transaction.partner_for(@receiver)).to eq(@issuer)
    end

    it "lending_transaction? works" do
      expect(@transaction.lending_transaction?(@issuer)).to be false
      expect(@transaction.lending_transaction?(@receiver)).to be true
    end

    it "borrowing_transaction? works" do
      expect(@transaction.borrowing_transaction?(@issuer)).to be true
      expect(@transaction.borrowing_transaction?(@receiver)).to be false
    end

    it "transaction_mesage works" do
      expect(@transaction.transaction_message(@issuer)).to eq("You borrowed: 1.5")
      expect(@transaction.transaction_message(@receiver)).to eq("You lended: 1.5")
    end

  end
end
