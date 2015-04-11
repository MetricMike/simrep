class CharacterSkill < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :character_skills
  belongs_to :skill, inverse_of: :character_skills

  accepts_nested_attributes_for :skill, allow_destroy: true
end
