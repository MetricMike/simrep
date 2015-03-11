class Character < ActiveRecord::Base
  has_paper_trail
  RACES = ["Human", "Elf", "Dwarf", "Gnome", "Ent", "Custom"]
  CULTURES = ["Cryogen", "Venthos", "Sengra", "Illumen/Lumiend", "Shaiden/Om'Oihanna", "Illugar/Unan Gens", "Shaigar/Alkon'Gol", "Minor", "Custom"]
  # (1..50).each { |i| EXP_CHART << EXP_CHART[i-1] + 15 + i-1 }
  EXP_CHART = [0, 15, 31, 48, 66, 85, 105, 126, 148, 171, 195, 220,
  246, 273, 301, 330, 360, 391, 423, 456, 490, 525, 561, 598, 636, 675, 715,
  756, 798, 841, 885, 930, 976, 1023, 1071, 1120, 1170, 1221, 1273, 1326,
  1380,1435, 1491, 1548, 1606, 1665, 1725, 1786, 1848, 1911, 1975]
  # (1..50).each { |i| SKILL_CHART << SKILL_CHART[i-1] + i/5 }
  SKILL_CHART = [0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 18, 19,
  20, 21, 22, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40,
  42, 43, 44, 45, 46, 48, 49, 50, 51, 52, 54, 55, 56, 57, 58, 60]
  
  belongs_to :user

  has_many :backgrounds, through: :character_backgrounds
  has_many :origins, through: :character_origins
  has_many :skills, through: :character_skills
  has_many :perks, through: :character_perks
  has_many :events, through: :character_events
  has_many :projects, through: :character_projects
  
  has_many :character_backgrounds
  has_many :character_origins
  has_many :character_skills
  has_many :character_perks
  has_many :character_events
  has_many :character_projects
  has_many :talents
  has_many :deaths
  
  accepts_nested_attributes_for :character_backgrounds, :character_origins, :character_skills, :character_perks, :character_events, :character_projects, :talents, :deaths

  validates :name, presence: true
  validates :race, inclusion: { in: RACES }
  validates :culture, inclusion: { in: CULTURES }
  validates :costume, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  
  def level
    @level = EXP_CHART.find_index { |i| self.experience <= i }
  end

  def exp_to_next
    @exp_to_next = EXP_CHART[self.level + 1] - self.experience
  end
  
  def experience
    @experience = self.events.reduce(31) do |sum, event|
      character_event = self.character_events.find_by :event_id => event.id
      if character_event.paid then sum += event.play_exp end
      if character_event.cleaned then sum += event.clean_exp end
      sum
    end
  end
  
  def skill_points_used
    @skill_points_used = self.skills.reduce(0) { |sum, el| sum + el.cost }
  end
  
  def skill_points_total
    @skill_points_total = SKILL_CHART[self.level]
  end
  
  def perk_points_used
    @perk_points_used = self.perks.reduce(0) { |sum, el| sum + el.cost }
  end
  
  def perk_points_total
    base = self.costume + 1
    @perk_points_total = self.skills.reduce(base) do |sum, skill|
      if skill.name.downcase == "added perks" then sum += base end
      sum
    end
    @perk_points_total += self.backgrounds.find { |b| b.name.start_with?("Paragon") } ? 4 : 0
  end
  
  def talent_points_used
    @talent_points_used = self.talents.reduce(0) do |sum, el|
      sum += (el.name.downcase != "unused" ? el.value : 0)
    end
  end
  
  def talent_points_total
    @talent_points_total = self.talents.reduce(0) { |sum, el| sum + el.value }
  end
  
  
  def history_approval=(bool)
    @history_approval = bool == "official" ? true : false
  end
  
  def history_approval
    @history_approval ? "official" : "unofficial"
  end
  
  def perm_chance_total
    @perm_chance_total = "???"
  end
end
