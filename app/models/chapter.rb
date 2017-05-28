class Chapter < ApplicationRecord
  has_many :characters, inverse_of: :chapter
  has_many :bank_accounts, inverse_of: :chapter
  has_many :events, inverse_of: :chapter

  def default_skills
    Character.skill_points_for_experience(default_xp)
  end

  def currencies
    case name
    when "Bastion"
      [Money::Currency.find(:vmk), Money::Currency.find(:sgd)]
    when "Holurheim"
      [Money::Currency.find(:hkr)]
    else
      []
    end
  end
end
