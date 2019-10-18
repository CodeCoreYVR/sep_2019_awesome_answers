# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Question.destroy_all

200.times do
  created_at = Faker::Date.backward(365 * 5)
  Question.create(
    # Faker is a ruby module. We access classes or
    # other modules inside of a module with the
    # `::` syntax. Here Hacker is a class within
    # the Faker module.
    title: Faker::Hacker.say_something_smart,
    body: Faker::ChuckNorris.fact,
    view_count: rand(100_000),
    created_at: created_at,
    updated_at: created_at
  )
end

question = Question.all

puts Cowsay.say("Gnerated #{Question.count} questions", :dragon)

# PASSWORD = "supersecret"
# Answer.delete.all
# Question.delete.all
# User.delete.all 

# super_user = User.create(
#   first_name: "Ham",
#   last_name: "Burger",
#   email: "shaft@hushyomouf.daddy",
#   password: PASSWORD
# )
# 10.times do
#   first_name = Faker::Name.first_name 
#   last_name = Faker::Name.last_name
#   User.create(
#     first_name: first_name,
#     last_name: last_name,
#     email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
#     password: PASSWORD
#   )
# end

# users = User.all
# puts Cowsay.say("Created #{users.count}, users", :tux)

# user: users.sample 

# puts "Login with #{super_user.emai} and password of '#{PASSWORD}'"
