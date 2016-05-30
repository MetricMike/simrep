class Skill < ApplicationRecord
  SOURCES = ["General", "Melee", "Ranged", "Magic", "Spellsword", "Prestige", "Ghost"]
  SAMPLE = [
    "Greater Vitality 1",
    "Added Perks",
    "First Trained Style (Counter)",
    "Adept Style (Braced)",
    "Additional Advanced Style (Stand)",
    "Trained Wizardry (Forces)",
    "Basic Sorcery (Ethereal)",
    "Trained Sorcery (Life, Healing)",
    "Still Spell (Matter, Gravity)",
    "Expanded Metamagic (Still Spell, Matter)",
    "Trained Strike (Break)",
    "Advanced Strike (Shove)",
    "Longer Effect Strike (Break)",
    "Trained Spellsword",
    "First Trained Sword-Spell (Life, Harming)",
    "Additional Advanced Sword-Spell (Forces, Ice)"
  ]

  scope :latest, -> { order(updated_at: :desc) }

  has_many :characters, through: :character_skills, inverse_of: :skills
  has_many :character_skills, inverse_of: :skill

  validates :source, inclusion: {in: SOURCES}
  validates :name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def display_name
    "#{self.source}|#{self.name} (#{self.cost})"
  end
end
