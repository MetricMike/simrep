# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def self.make_fake_projects()
  20.times {Project.create!(
    name: Faker::Hacker.adjective + Faker::Hacker.noun,
    description: Faker::Lorem.sentence(2, true, 3))}
end

def self.make_fake_events()
  30.times {Event.create!(
    campaign: Faker::Hacker.adjective + Faker::Hacker.noun,
    weekend: Faker::Date.backward(1000),
    play_exp: [10, 20, 20, 20, 20, 40].sample,
    clean_exp: [5, 5, 5, 5, 10].sample)}
end

def self.make_fake_user(email, admin=false)
  User.create!(
    email: email,
    admin: admin,
    password: email[/(\w+)/],
    password_confirmation: email[/(\w+)/])
end

def self.make_fake_characters(user)
  character = user.characters.create!(
    name: Faker::Name.name,
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
  5.times {attend_event(character)}
  5.times {contribute_to_project(character)}
end

def self.attend_event(character)
  randomEvent = Event.all.sample
  
  character.character_events.create!(
    event_id: randomEvent.id,
    paid: [true, true, true, false].sample,
    cleaned: [true, false].sample)
end

def self.contribute_to_project(character)
  randomProject = Project.all.sample
  characterProject = character.character_projects.find_or_initialize_by(project: randomProject)
  characterProject.update!(total_tu: characterProject.total_tu.nil? ? 2 : characterProject.total_tu + 2)
  if randomProject.leader.blank? then randomProject.update(leader: character) end
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

#Events & Projects
make_fake_events
make_fake_projects

#Users
make_fake_user("orphaned@example.com")
make_fake_user("sterling.archer@isis.gov")
make_fake_user("malory.archer@isis.gov", true)
make_fake_user("lana.kane@isis.gov")
make_fake_user("cyril.figgis@isis.gov")
             
#Characters
[User.first, User.second, User.last].each { |u| make_fake_characters(u) }
