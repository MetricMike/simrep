class Birthright < ApplicationRecord
  has_many :characters, through: :character_birthrights, inverse_of: :birthrights
  has_many :character_birthrights, inverse_of: :birthright

  SOURCES = (Character::RACES|Character::CULTURES|[
    "Template: Clocksmith",
    "Template: Proto"]
  )
  SAMPLE = [
    "Arcane Aptitude",
    "Gnomish Luck",
    "Proto Form",
  ]

  validates :source, inclusion: {in: SOURCES }
  validates :name, presence: true

  def display_name
    "#{self.source}|#{self.name}"
  end
end
