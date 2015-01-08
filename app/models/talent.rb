class Talent < ActiveRecord::Base
  RANKS = ["Untrained", "Apprentice", "Journeyman", "Master", "Grandmaster"]
  GROUPS = ["Favor", "Scholarship", "Profession", "Craft", "Trick", "General", "Custom"]
  
  belongs_to :character
  
  validates :name, presence: true
  validates :spec, exclusion: { in: [nil] }
  validates :group, inclusion: {in: GROUPS}
  validates :rank, inclusion: {in: RANKS}
  validates :value, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
