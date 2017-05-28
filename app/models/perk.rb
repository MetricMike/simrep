class Perk < ApplicationRecord
  SOURCES = Character::RACES|Character::CULTURES|["Ghost"]
  SAMPLE = [
    "Ancient Device",
    "(Acrobat) Scamper",
    "Subschool Resistance (Matter, Gravity)"
  ]

  scope :latest,    ->            { order(updated_at: :desc) }
  scope :popular,   -> (count=5)  { where("characters_count >= ?", count) }
  scope :canon,     ->            { where.not(reviewed_at: nil) }
  scope :non_canon, ->            { where(reviewed_at: nil) }

  has_many :characters, through: :character_perks, inverse_of: :perks
  has_many :character_perks, inverse_of: :perk

  validates :source, presence: true#, inclusion: {in: SOURCES}
  validates :name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def display_name
    "#{self.source} | #{self.name} (#{self.cost} SP)"
  end
end
