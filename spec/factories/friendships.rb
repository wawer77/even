FactoryBot.define do
  factory :friendship do
    user_id { FactoryBot.create(:user).id }
    friend_id { FactoryBot.create(:user).id }
    invitor_id { user_id }
  end
end
