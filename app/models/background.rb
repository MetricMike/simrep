class Background < ApplicationRecord
  has_many :character_backgrounds, inverse_of: :background
  has_many :characters, through: :character_backgrounds, inverse_of: :backgrounds

  validates :name, presence: true

  def display_name
    "#{self.name}"
  end
end
