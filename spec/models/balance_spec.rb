require 'rails_helper'

RSpec.describe Balance, type: :model do
  before do
    @balance = FactoryBot.create(:balance)
    @balance.users << [User.find(@balance.creator_id),User.find(@balance.partner_id)] #not sure it should be added here, but it works
  end

  describe "creation" do
    it "can be created" do
      expect(@balance).to be_valid
    end
  end

  describe "validations" do
    it "cannot be created without name" do
      @balance.name = nil
      expect(@balance).to_not be_valid
    end

    it "can be created without description" do
      @balance.description = nil
      expect(@balance).to be_valid
    end

    it "cannot be created without 2 different users" do
      @two_users = [@balance.users.first,@balance.users.first]
      @balance.users.replace(@two_users)
      expect(@balance).to_not be_valid
    end
  end
end
