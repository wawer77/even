FactoryBot.define do
  sequence :email do |n|
    "test#{n}@test.com"
  end

  factory :user do
    first_name {"Jon"}
    last_name {"Snow"}
    username {"Jon-Snow"}
    email {generate :email}
    password {"foobar"}
    password_confirmation {"foobar"}
  end
end
