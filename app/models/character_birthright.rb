class CharacterBirthright < ApplicationRecord
  belongs_to :character, inverse_of: :character_birthrights
  belongs_to :birthright, inverse_of: :character_birthrights

  accepts_nested_attributes_for :birthright, allow_destroy: true

  def display_name
    "#{self.character.display_name}'s #{self.birthright.display_name}"
  end
end
