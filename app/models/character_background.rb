class CharacterBackground < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :character_backgrounds
  belongs_to :background, inverse_of: :character_backgrounds

  accepts_nested_attributes_for :background
end
