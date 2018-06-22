class CharacterSkill < ApplicationRecord
  belongs_to :character, inverse_of: :character_skills
  belongs_to :skill, inverse_of: :character_skills, counter_cache: :characters_count

  accepts_nested_attributes_for :skill, allow_destroy: true

  def display_name
    if self.character
      "#{self.character.display_name}'s #{self.skill.display_name}"
    else
      "ORPHANED PLS DELETE: #{self.skill.display_name}"
    end
  end
end
