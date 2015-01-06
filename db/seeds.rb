# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def self.make_fake_user(email)
  User.create!(email: email, password: email[/(\w+)/], password_confirmation: email[/(\w+)/])
end

def self.make_fake_character(user)
  user.characters.create!(
    name: Faker::Name.name,
    experience: rand(0..999),
    race: Faker::SimTerra.race,
    culture: Faker::SimTerra.culture,
    costume: rand(0..3),
    costume_checked: Faker::Date.backward(365),
    history_approval: [true, false].sample,
    history_link: Faker::Internet.url
    )
end

#Users
make_fake_user("orphaned@example.com")
make_fake_user("sterling.archer@isis.gov")
make_fake_user("malory.archer@isis.gov")
make_fake_user("lana.kane@isis.gov")
make_fake_user("cyril.figgis@isis.gov")
             
#Characters
3.times do |n|
  make_fake_character(User.first)
  make_fake_character(User.second)
  make_fake_character(User.last)
end
