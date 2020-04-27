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
                    first_name: "Firstuser - name",
                    last_name: "Firstuser - lastname",
                    username: "Firstuser-username")

@user = User.create!(email: "user2@test.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    first_name: "Seconduser - name",
                    last_name: "Seconduser - lastname",
                    username: "Seconduser - username")

@balance1 = Balance.create!(name: "firstbalance",
                            description: "firstuser owes money",
                            partner_id: 1,
                            creator_id: 2)                   

@balance2 = Balance.create!(name: "secondbalance",
                            description: "seconduser owes money",
                            partner_id: 2,
                            creator_id: 1)                    
                    
@transaction = Transaction.create!(description: "transaction 1",
                                    value: 10,
                                    issuer_id: 1,
                                    receiver_id: 2,
                                    send_money: false,
                                    balance_id: @balance1.id)
    
@transaction = Transaction.create!(description: "transaction 2",
                                    value: 5,
                                    issuer_id: 1,
                                    receiver_id: 2,
                                    send_money: true,
                                    balance_id: @balance1.id)

@transaction = Transaction.create!(description: "transaction 3",
                                    value: 10,
                                    issuer_id: 2,
                                    receiver_id: 1,
                                    send_money: false,
                                    balance_id: @balance2.id)
    
@transaction = Transaction.create!(description: "transaction 4",
                                    value: 5,
                                    issuer_id: 2,
                                    receiver_id: 1,
                                    send_money: true,
                                    balance_id: @balance2.id)
                           
puts "2 regular users, 2 balances and 4 transactions created"
