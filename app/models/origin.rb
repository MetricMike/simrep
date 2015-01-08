class Origin < ActiveRecord::Base
  has_many :characters, through: :character_origins
  
  validates :source, inclusion: {in: (Character::RACES|Character::CULTURES) }
  validates :name, presence: true
end
