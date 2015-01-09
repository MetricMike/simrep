class CharacterBackground < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :background
  belongs_to :background, inverse_of: :character

  accepts_nested_attributes_for :background
end
