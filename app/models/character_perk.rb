class CharacterPerk < ActiveRecord::Base
  belongs_to :character
  belongs_to :perk
  
  accepts_nested_attributes_for :perk
end
