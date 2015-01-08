class Skill < ActiveRecord::Base
  SOURCES = ["General", "Fighter", "Marksman", "Magic"]
  
  has_many :characters, through: :character_skills
  
  validates :source, inclusion: {in: SOURCES}
  validates :name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
end
