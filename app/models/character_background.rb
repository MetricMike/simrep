class CharacterBackground < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :background
  
  accepts_nested_attributes_for :background
end
