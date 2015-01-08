class CharacterPerk < ActiveRecord::Base
  belongs_to :character
  belongs_to :perk
end
