# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'database_cleaner'
DatabaseCleaner.clean_with(:truncation)

@user1 = User.create!(email: "user@test.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    first_name: "1name",
                    last_name: "1lastname",
                    username: "1username")

@user2 = User.create!(email: "user2@test.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    first_name: "2name",
                    last_name: "2lastname",
                    username: "2username")

@user3 = User.create!(email: "user3@test.com",
                        password: "foobar",
                        password_confirmation: "foobar",
                        first_name: "3name",
                        last_name: "3lastname",
                        username: "3username")

@friendship1a = Friendship.create(user_id: 1,
                                friend_id: 2,
                                status: 1,
                                invitor_id: 1)
@friendship1b = Friendship.create(user_id: 2,
                                friend_id: 1,
                                status: 1,
                                invitor_id: 1)
@friendship2a = Friendship.create(user_id: 1,
                                friend_id: 3,
                                status: 1,
                                invitor_id: 1)
@friendship2b = Friendship.create(user_id: 3,
                                friend_id: 1,
                                status: 1,
                                invitor_id: 1)

@balance1 = Balance.create(creator_id: @user1.id, partner_id: @user2.id, name: "#{@user1.username} - #{@user2.username}", description: "1 owes", updated_by_id: @user1.id)
@balance1.users << [@user1, @user2,]

@balance2 = Balance.create(creator_id: @user1.id, partner_id: @user3.id, name: "#{@user1.username} - #{@user3.username}", description: "1 lends", updated_by_id: @user1.id)
@balance2.users << [@user1, @user3,]

@transaction = Transaction.create!(description: "1 borrowing",
                                    value: 10,
                                    issuer_id: 1,
                                    receiver_id: 2,
                                    send_money: false,
                                    balance_id: @balance1.id,
                                    updated_by_id: 1,
                                    creator_id: 1)
    
@transaction = Transaction.create!(description: "1 lending",
                                    value: 5,
                                    issuer_id: 1,
                                    receiver_id: 2,
                                    send_money: true,
                                    balance_id: @balance1.id,
                                    updated_by_id: 1,
                                    creator_id: 1)

@transaction = Transaction.create!(description: "1 lending",
                                    value: 10,
                                    issuer_id: 3,
                                    receiver_id: 1,
                                    send_money: false,
                                    balance_id: @balance2.id,
                                    updated_by_id: 3,
                                    creator_id: 3)
    
@transaction = Transaction.create!(description: "1 borrowing",
                                    value: 5,
                                    issuer_id: 3,
                                    receiver_id: 1,
                                    send_money: true,
                                    balance_id: @balance2.id,
                                    updated_by_id: 3,
                                    creator_id: 3)
