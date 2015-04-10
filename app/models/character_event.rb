class CharacterEvent < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :event

  accepts_nested_attributes_for :character, :event

  after_create do |character_event|
    current_character = Character.find_by(character_id: character_event.character_id)
    current_character.talents.each { |talent| talent.investment_limit += 2; talent.save }
  end
end
