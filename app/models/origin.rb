class Origin < ActiveRecord::Base
  has_paper_trail
  has_many :characters, through: :character_origins, inverse_of: :origins
  has_many :character_origins

  validates :source, inclusion: {in: (Character::RACES|Character::CULTURES) }
  validates :name, presence: true
end
