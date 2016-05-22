class Perk < ApplicationRecord
  has_many :characters, through: :character_perks, inverse_of: :perks
  has_many :character_perks, inverse_of: :perk
  SOURCES = Character::RACES|Character::CULTURES|["Ghost"]

  scope :latest, -> { order(updated_at: :desc) }

  validates :source, inclusion: {in: SOURCES}
  validates :name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def display_name
    "#{self.source}|#{self.name} (#{self.cost})"
  end
end
