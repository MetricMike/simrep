class CharacterSkill < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :skill
  
  accepts_nested_attributes_for :skill
end
