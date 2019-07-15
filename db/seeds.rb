# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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

puts "2 regular user created"
