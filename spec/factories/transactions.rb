FactoryBot.define do
  factory :transaction do
    description { "MyText" }
    value { 1.5 }
    issuer_id { 1 }
    receiver_id { 1 }
    send_money { false }
    balance_id { 1 }
  end
end
