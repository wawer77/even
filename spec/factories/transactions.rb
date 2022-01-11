FactoryBot.define do
  factory :transaction do
    description { "TransactionDescription" }
    value { 1.5 }
    issuer_id { FactoryBot.create(:user).id }
    receiver_id { FactoryBot.create(:user).id }
    creator_id  { issuer_id }
    editor_id  { issuer_id }
    send_money { false }
    balance_id { FactoryBot.create(:balance, creator_id: issuer_id, partner_id: receiver_id).id }
  end
end
