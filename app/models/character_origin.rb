class CharacterOrigin < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :origin
  
  accepts_nested_attributes_for :origin
end
