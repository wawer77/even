FactoryBot.define do
  factory :balance do
    name { "BalanceName" }
    description { "BalanceDescription" }
    creator_id { FactoryBot.create(:user).id }
    editor_id { creator_id }
    partner_id { FactoryBot.create(:user).id }
    end
end
