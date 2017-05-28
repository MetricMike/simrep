class Origin < ApplicationRecord
  SOURCES = (Character::RACES|Character::CULTURES|[
    "Template: Clocksmith",
    "Template: Proto"]
  )
  SAMPLE = [
    "Cryogen",
    "Common House of Arcane",
  ]

  scope :latest,    ->            { order(updated_at: :desc) }
  scope :popular,   -> (count=5)  { where("characters_count >= ?", count) }
  scope :canon,     ->            { where.not(reviewed_at: nil) }
  scope :non_canon, ->            { where(reviewed_at: nil) }

  has_many :characters, through: :character_origins, inverse_of: :origins
  has_many :character_origins, inverse_of: :origin

  validates :source, presence: true#, inclusion: {in: SOURCES }
  validates :name, presence: true

  def display_name
    "#{self.source} | #{self.name}"
  end
end
