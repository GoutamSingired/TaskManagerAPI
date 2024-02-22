# db/seeds.rb
require 'faker'

# Delete existing users if any
User.destroy_all

# Create 100 users
100.times do
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email
  )
end

puts "100 users created successfully."
