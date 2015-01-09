class Background < ActiveRecord::Base
  has_many :characters, through: :character_backgrounds
  has_many :character_backgrounds
  
  validates :name, presence: true
end
