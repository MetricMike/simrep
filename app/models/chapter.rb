class Chapter < ApplicationRecord
  include ConstantCache
  cache_constants

  has_many :characters, inverse_of: :chapter
  has_many :bank_accounts, inverse_of: :chapter
  has_many :events, inverse_of: :chapter

  def default_skills
    Character.skill_points_for_experience(default_xp)
  end
end
