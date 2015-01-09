class CharacterSkill < ActiveRecord::Base
  belongs_to :character
  belongs_to :skill
  
  accepts_nested_attributes_for :skill
end
