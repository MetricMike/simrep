# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def self.make_fake_user(email)
  User.create!(
    email: email,
    password: email[/(\w+)/],
    password_confirmation: email[/(\w+)/])
end

def self.make_fake_characters(user)
  character = user.characters.create!(
    name: Faker::Name.name,
    experience: rand(0..999),
    race: Character::RACES.sample,
    culture: Character::CULTURES.sample,
    costume: rand(0..3),
    costume_checked: Faker::Date.backward(365),
    history_approval: [true, false].sample,
    history_link: Faker::Internet.url)
    
  make_fake_skills(character)
  make_fake_perks(character)
  make_fake_talents(character)
  make_fake_origins(character)
  make_fake_backgrounds(character)
  make_fake_deaths(character)
end

def self.make_fake_skills(character)
  5.times {character.skills.create!(
    source: Skill::SOURCES.sample,
    name: Faker::Hacker.ingverb,
    cost: rand(0..5))}
end

def self.make_fake_perks(character)
  5.times {character.perks.create!(
    source: [character.race, character.culture].sample,
    name: Faker::Hacker.ingverb,
    cost: rand(0..5))}
end

def self.make_fake_talents(character)
  5.times {character.talents.create!(
    group: Talent::GROUPS.sample,
    name: Faker::Hacker.ingverb,
    rank: Talent::RANKS.sample,
    value: rand(0..40),
    spec: [true, false, false].sample)}
end

def self.make_fake_origins(character)
  2.times {character.origins.create!(
    source: [character.race, character.culture].sample,
    name: Faker::Hacker.ingverb,
    detail: Faker::Hacker.abbreviation)}
end

def self.make_fake_backgrounds(character)
  3.times {character.backgrounds.create!(
    name: Faker::Hacker.ingverb,
    detail: Faker::Hacker.abbreviation)}
end

def self.make_fake_deaths(character)
  3.times {character.deaths.create!(
    description: Faker::Lorem.sentence(2, true, 3),
    physical: Faker::Lorem.sentence(2, true, 3),
    roleplay: Faker::Lorem.sentence(2, true, 3),
    date: Faker::Date.backward(365),
    perm_chance: [true, true, true, false].sample)}
end

#Users
make_fake_user("orphaned@example.com")
make_fake_user("sterling.archer@isis.gov")
make_fake_user("malory.archer@isis.gov")
make_fake_user("lana.kane@isis.gov")
make_fake_user("cyril.figgis@isis.gov")
             
#Characters
[User.first, User.second, User.last].each { |u| make_fake_characters(u) }
