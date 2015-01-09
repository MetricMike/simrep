class CharacterPerk < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :perk
  belongs_to :perk, inverse_of: :character

  accepts_nested_attributes_for :perk
end
