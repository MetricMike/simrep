class CharacterPerk < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :perk
  
  accepts_nested_attributes_for :perk
end
