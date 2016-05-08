class CraftingPoint < ApplicationRecord
  TYPES = ["Blacksmithing", "Focal Artificing", "Shattersmithing", "Engineering", "Architect", "Alchemy"]
  belongs_to :character

  validates :type, inclusion: { in: TYPES }
  validates :unranked, numericality: { only_integer: true, less_than_or_equal_to: 200, greater_than_or_equal_to: 0 }
  validates :apprentice, numericality: { only_integer: true, less_than_or_equal_to: 200, greater_than_or_equal_to: 0 }
  validates :journeyman, numericality: { only_integer: true, less_than_or_equal_to: 200, greater_than_or_equal_to: 0 }
  validates :master, numericality: { only_integer: true, less_than_or_equal_to: 200, greater_than_or_equal_to: 0 }

  def display_name
    "#{self.character.display_name}'s #{self.unranked}U/#{self.apprentice}A/#{self.journeyman}J/#{self.master}M #{self.type} CP"
  end
end