class CharacterSkill < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :skill
  belongs_to :skill, inverse_of: :character

  accepts_nested_attributes_for :skill
end
