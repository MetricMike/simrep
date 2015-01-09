class Background < ActiveRecord::Base
  has_paper_trail
  has_many :characters, through: :character_backgrounds, inverse_of: :backgrounds
  has_many :character_backgrounds

  validates :name, presence: true
end
