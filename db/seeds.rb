# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
PASSWORD = "supersecret"
NUM_QUESTIONS = 100

Like.delete_all
Answer.delete_all
Question.delete_all
User.delete_all

super_user = User.create(
  first_name: "Ham",
  last_name: "Burger",
  email: "shaft@hushyomouf.daddy",
  password: PASSWORD,
  is_admin: true
)
10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end

users = User.all

NUM_QUESTIONS.times do
  created_at = Faker::Date.backward(days: 365)
  q = Question.create(
    # Faker is a ruby module. We access classes or
    # other modules inside of a module with the
    # `::` syntax. Here Hacker is a class within
    # the Faker module.
    title: Faker::Hacker.say_something_smart,
    body: Faker::ChuckNorris.fact,
    view_count: rand(100_000),
    created_at: created_at,
    updated_at: created_at,
    user: users.sample
  )
  if q.valid?
    q.answers = rand(0..15).times.map do
      Answer.new(
        body: Faker::GreekPhilosophers.quote,
        user: users.sample
      )
    end
    q.likers = users.shuffle.slice(0, rand(users.count))
  end
end

question = Question.all

puts Cowsay.say("Created #{Like.count}, likes", :ghostbusters)
puts Cowsay.say("Generated #{Question.count} questions", :dragon)
puts Cowsay.say("Generated #{Answer.count} answers", :cow)
puts Cowsay.say("Created #{users.count}, users", :tux)
puts "Login with #{super_user.email} and password of '#{PASSWORD}'"
