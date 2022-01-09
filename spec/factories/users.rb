FactoryBot.define do
  sequence :email do |n|
    "test#{n}@test.com"
  end

  sequence :username do |n|
    "username#{n}"
  end

  factory :user do
    first_name {"Jon"}
    last_name {"Snow"}
    username {generate :username}
    email {generate :email}
    password {"foobar"}
    password_confirmation {"foobar"}
  end
end
