class CharacterPerk < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :character_perks
  belongs_to :perk, inverse_of: :character_perks

  accepts_nested_attributes_for :perk
end
