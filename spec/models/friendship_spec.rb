require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before do
    @friendship = FactoryBot.create(:friendship)
  end

  describe "creation" do
    it "can be created" do
      expect(@friendship).to be_valid
    end
  end

  describe "validations" do
    it "cannot be created without friend" do
      @friendship.friend = nil
      expect(@friendship).to_not be_valid
    end

    it 'cannot have the same user as both sides' do
      @friendship.friend_id = @friendship.user_id
      expect(@friendship).to_not be_valid
    end

    it 'is created with a pending status' do
      expect(@friendship.status).to eq("pending")
    end
  end
end
