class CharacterEvent < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :character_events
  belongs_to :event, inverse_of: :character_events

  accepts_nested_attributes_for :character, :event, allow_destroy: true

  after_create :give_attendance_awards

  def give_attendance_awards
    current_character = Character.find(self.character_id)
    current_character.talents.each { |talent| talent.investment_limit += 2; talent.save }

    current_character.unused_talents += 2

    current_character.decrement_death if self.paid
    current_character.save
  end

  def display_name
    "#{self.character.display_name}'s #{self.event.display_name}"
  end
end
