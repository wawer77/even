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
                    
@transaction = Transaction.create!(description: "transaction 1",
                                    value: 10,
                                    issuer_id: 1,
                                    receiver_id: 2,
                                    send_money: true)
    
@transaction = Transaction.create!(description: "transaction 2",
                                    value: 10,
                                    issuer_id: 1,
                                    receiver_id: 2,
                                    send_money: false)
                           
puts "2 regular users and 2 transactions created"
