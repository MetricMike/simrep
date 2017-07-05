class Birthright < ApplicationRecord
  SOURCES = (Character::RACES|Character::CULTURES|[
    "Template: Clocksmith",
    "Template: Proto"]
  )
  SAMPLE = [
    "Arcane Aptitude",
    "Gnomish Luck",
    "Proto Form",
  ]

  scope :latest,    ->            { order(updated_at: :desc) }
  scope :popular,   -> (count=5)  { where("characters_count >= ?", count) }
  scope :canon,     ->            { where.not(reviewed_at: nil) }
  scope :non_canon, ->            { where(reviewed_at: nil) }

  has_many :character_birthrights, inverse_of: :birthright
  has_many :characters, through: :character_birthrights, inverse_of: :birthrights

  validates :source, presence: true#, inclusion: { in: SOURCES }
  validates :name, presence: true

  def display_name
    "#{self.source} | #{self.name}"
  end
end
