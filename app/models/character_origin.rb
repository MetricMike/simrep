class CharacterOrigin < ActiveRecord::Base
  belongs_to :character
  belongs_to :origin
  
  accepts_nested_attributes_for :origin
end
