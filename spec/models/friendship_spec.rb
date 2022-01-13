require 'rails_helper'

RSpec.describe Friendship, type: :model do
  
  describe "creation part" do
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

      it "cannot have the same user as both sides" do
        @friendship.friend_id = @friendship.user_id
        expect(@friendship).to_not be_valid
      end

      it "is created with a pending status" do
        expect(@friendship.status).to eq("pending")
      end
    end
  end

  describe "methods part" do
    before do
      Friendship.create_reverse_friendships(FactoryBot.create(:user).id, FactoryBot.create(:user).id)
      @friendship = Friendship.last
    end

    it "create reverse friendship works" do
      expect {
        Friendship.create_reverse_friendships(FactoryBot.create(:user).id, FactoryBot.create(:user).id)
      }.to change(Friendship, :count).by(2)
    end

    it "destroy reverse friendship works" do
      expect {
        Friendship.destroy_reverse_friendships(@friendship.user_id, @friendship.friend_id)
      }.to change(Friendship, :count).by(-2)
    end

    it "reverse friendship method works" do
      expect(@friendship.reverse_friendship.id).to be(Friendship.find(@friendship.id - 1).id)
    end

    it "confirm reverse friendships works" do
      @friendship.confirm_reverse_friendships
      expect(@friendship.reload).to have_attributes(:status => "confirmed")
      expect(Friendship.find(@friendship.id - 1)).to have_attributes(:status => "confirmed")
    end
  end
end
