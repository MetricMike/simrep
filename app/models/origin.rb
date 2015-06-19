class Origin < ActiveRecord::Base
  has_paper_trail
  has_many :characters, -> { distinct }, through: :character_origins, inverse_of: :origins
  has_many :character_origins, inverse_of: :origin

  validates :source, inclusion: {in: (Character::RACES|Character::CULTURES) }
  validates :name, presence: true

  def display_name
    "#{self.source}|#{self.name}"
  end
end
