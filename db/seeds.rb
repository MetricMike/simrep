# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Users
User.create!(email:                  "orphaned@example.com",
             password:               "orphaned",
             password_confirmation:  "orphaned")


User.create!(email:                  "sterling.archer@isis.gov",
             password:               "sterling",
             password_confirmation:  "sterling")
             
User.create!(email:                  "malory.archer@isis.gov",
             password:               "malory",
             password_confirmation:  "malory")
             
User.create!(email:                  "lana.kane@isis.gov",
             password:               "lana",
             password_confirmation:  "lana")
             
User.create!(email:                  "cyril.figgis@isis.gov",
             password:               "cyril",
             password_confirmation:  "cyril")
             
#Characters
3.times do |n|
  User.second.characters.create!(
    name: Faker::Name.name,
    experience: Faker::Number.number(3))
end

3.times do |n|
  User.last.characters.create!(
    name: Faker::Name.name,
    experience: Faker::Number.number(3))
end

#orphans!
5.times do |n|
  User.first.characters.create!(
    name: Faker::Name.name,
    experience: Faker::Number.number(3))
end