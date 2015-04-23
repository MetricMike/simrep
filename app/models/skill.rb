class Skill < ActiveRecord::Base
  has_paper_trail
  SOURCES = ["General", "Fighter", "Marksman", "Magic", "Ghost"]

  has_many :characters, through: :character_skills, inverse_of: :skills
  has_many :character_skills, inverse_of: :skill

  validates :source, inclusion: {in: SOURCES}
  validates :name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
end
