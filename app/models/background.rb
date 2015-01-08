class Background < ActiveRecord::Base
  has_many :characters, through: :character_backgrounds
  
  validates :name, presence: true
end
