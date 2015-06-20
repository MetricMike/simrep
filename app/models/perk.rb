class Perk < ActiveRecord::Base
  has_paper_trail
  has_many :characters, -> { distinct }, through: :character_perks, inverse_of: :perks
  has_many :character_perks, inverse_of: :perk

  default_scope { order(updated_at: :desc) }

  validates :source, inclusion: {in: (Character::RACES|Character::CULTURES|["Ghost"])}
  validates :name, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def display_name
    "#{self.source}|#{self.name} (#{self.cost})"
  end
end
