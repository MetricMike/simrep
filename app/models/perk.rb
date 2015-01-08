class Perk < ActiveRecord::Base
  has_many :characters, through: :character_perks
  
  validates :source, inclusion: {in: (Character::RACES|Character::CULTURES)}
  validates :name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
end
