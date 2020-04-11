# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'database_cleaner'
DatabaseCleaner.clean_with(:truncation)

@user = User.create!(email: "user@test.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    first_name: "Firstuser",
                    last_name: "Firstuser",
                    username: "Firstuser")

@user = User.create!(email: "user2@test.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    first_name: "Seconduser",
                    last_name: "Seconduser",
                    username: "Seconduser")
                    
@balance = Balance.create!(name: "balance1",
                          description: "balance description",
                          value: 0,
                          owner_id: 1,
                          owner_type: 'User',
                          added_user_id: 2,
                          added_user_type: 'User')
                            
@balance = Balance.create!(name: "balance2",
                            description: "balance description",
                            value: 10,
                            owner_id: 1,
                            owner_type: 'User',
                            added_user_id: 2,
                            added_user_type: 'User')
                           
@balance = Balance.create!(name: "balance3",
                            description: "balance description",
                            value: -10,
                            owner_id: 1,
                            owner_type: 'User',
                            added_user_id: 2,
                            added_user_type: 'User')

puts "2 regular users and 3 balances created"
