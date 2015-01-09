class CharacterBackground < ActiveRecord::Base
  belongs_to :character
  belongs_to :background
  
  accepts_nested_attributes_for :background
end
