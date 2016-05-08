class CharacterBackground < ApplicationRecord
  belongs_to :character, inverse_of: :character_backgrounds
  belongs_to :background, inverse_of: :character_backgrounds

  accepts_nested_attributes_for :background, allow_destroy: true

  def display_name
    "#{self.character.display_name}'s #{self.background.display_name}"
  end
end
