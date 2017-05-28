class CharacterPerk < ApplicationRecord
  belongs_to :character, inverse_of: :character_perks
  belongs_to :perk, inverse_of: :character_perks, counter_cache: :characters_count

  accepts_nested_attributes_for :perk, allow_destroy: true

  def display_name
    "#{self.character.display_name}'s #{self.perk.display_name}"
  end
end
