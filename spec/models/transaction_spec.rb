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
end
