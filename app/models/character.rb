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
  DEATH_PERCENTAGES = [0, 10, 30, 60, 90]
  DEATH_COUNTER = [0, 3, 2, 1, 0]
  BASE_XP = 31

  scope :by_name_asc, -> { order(name: :asc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :for_index, -> { includes(:events, :backgrounds) }

  belongs_to :user, inverse_of: :characters

  has_many :backgrounds, through: :character_backgrounds, inverse_of: :characters, dependent: :destroy
  has_many :origins, through: :character_origins, inverse_of: :characters, dependent: :destroy
  has_many :skills, through: :character_skills, inverse_of: :characters, dependent: :destroy
  has_many :perks, through: :character_perks, inverse_of: :characters, dependent: :destroy
  has_many :events, through: :character_events, inverse_of: :characters, dependent: :destroy
  has_many :projects, through: :project_contributions, inverse_of: :characters, dependent: :destroy

  has_many :character_backgrounds, inverse_of: :character, dependent: :destroy
  has_many :character_origins, inverse_of: :character, dependent: :destroy
  has_many :character_skills, inverse_of: :character, dependent: :destroy
  has_many :character_perks, inverse_of: :character, dependent: :destroy
  has_many :character_events, inverse_of: :character, dependent: :destroy
  has_many :project_contributions, inverse_of: :character, dependent: :destroy
  has_many :talents, inverse_of: :character, dependent: :destroy
  has_many :deaths, inverse_of: :character, dependent: :destroy
  has_many :bank_accounts, foreign_key: :owner_id, dependent: :destroy
  has_many :crafting_points, dependent: :destroy

  accepts_nested_attributes_for :character_backgrounds, :character_origins, :character_skills,
                                :character_perks, :character_events, :bank_accounts,
                                :crafting_points, allow_destroy: true
  accepts_nested_attributes_for :project_contributions, :talents, :deaths, :origins, :backgrounds,
                                :events, :skills, :perks, allow_destroy: true

  validates :name, presence: true
  validates :race, inclusion: { in: RACES }
  validates :culture, inclusion: { in: CULTURES }
  validates :costume, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 4 }
  validates :unused_talents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_create :turn_off_nested_callbacks
  after_create :turn_on_nested_callbacks, :open_bankaccount

  attr_writer :perm_chance, :perm_counter

  def level
    @level = EXP_CHART.rindex { |i| self.experience >= i }
  end

  def exp_to_next
    @exp_to_next = EXP_CHART[self.level + 1] - self.experience
  end

  def last_event
    @last_event = self.events.newest.try(:first)
  end

  def first_event
    @first_event = self.events.oldest.try(:first)
  end

  def experience
    pay_xp = self.character_events.paid_with_xp.pluck('events.play_exp').reduce(0, :+)
    clean_xp = self.character_events.cleaned_with_xp.pluck('events.clean_exp').reduce(0, :+)
    background_xp = (self.backgrounds.find { |b| b.name.start_with?("Experienced") }) ? 20 : 0
    @experience = BASE_XP + pay_xp + clean_xp + background_xp
  end

  def skill_points_used
    @skill_points_used = self.skills.reduce(0) { |sum, el| sum + el.cost }
  end

  def skill_points_total
    multiplier = (self.origins.find { |o| o.name.start_with?("Template: Proto") }) ? 2 : 1
    @skill_points_total = SKILL_CHART[self.level*multiplier]
  end

  def perk_points_used
    @perk_points_used = self.perks.reduce(0) { |sum, el| sum + el.cost }
  end

  def perk_points_total
    added_perks = self.skills.find { |s| s.name.downcase == "added perks" }
    @perk_points_total = self.costume +
                          (added_perks ? (added_perks.cost * (self.costume + 1)) : 0) +
                          (self.backgrounds.find { |b| b.name.start_with?("Paragon") } ? 4 : 0)
  end

  def invest_in_project(amt, talent=nil)
    self.unused_talents -= amt
    self.talents.find(talent).invest(amt, false) if talent.present?
    self.save
  end

  def talent_points_total
    @talent_points_total = self.talents.reduce(0) { |sum, el| sum + el.value }
  end

  #def history_approval=(bool)
  #  @history_approval = bool == "official" ? true : false
  #end

  #def history_approval
  #  @history_approval ? "official" : "unofficial"
  #end

  def attend_event(event_id, paid=false, cleaned=false, check_coupon=false, override=false)
    attendance = self.character_events.find_or_create_by(event_id: event_id)
    award_paid(attendance, (paid || override))
    award_cleaned(attendance, (cleaned || override), check_coupon)
  end

  def award_paid(char_event, bool=false)
    char_event.update(paid: bool)
  end

  def award_cleaned(char_event, bool=false, check_coupon=false)
    if (bool.nil? && check_coupon.present?)
      clean_coupon = Event.where(id: self.user.free_cleaning_event_id).first
      if (clean_coupon.nil? || clean_coupon.weekend <= 1.year.ago)
        self.user.update(free_cleaning_event_id: char_event.event_id)
        bool = true
      end
    end
    char_event.update(cleaned: bool)
  end

  def perm_counter
    @perm_counter ||= (record_deaths; @perm_counter)
  end

  def perm_chance
    @perm_chance ||= (record_deaths; @perm_chance)
  end

  def record_deaths
    @perm_chance = 0
    @perm_counter = 0

    deaths = self.deaths.countable.latest.to_a
    next_death = deaths.try(:pop)
    while prev_death = next_death
      next_death = deaths.try(:pop)
      self.increment_death if prev_death

      if next_death
        # I'm not crazy about how this reads. It feels backwards, but it's 0121 on a weeknight.
        prev_death.events_since(next_death.weekend).times { self.decrement_death }
      else #most recent death
        prev_death.events_since.times {self.decrement_death }
      end
    end
  end
  alias_method :recount_deaths, :record_deaths

  # Useless methods but I don't feel like excising them yet.
  def increment_death
    index = [DEATH_PERCENTAGES.index(@perm_chance) + 1, DEATH_PERCENTAGES.size - 1].min
    @perm_chance = DEATH_PERCENTAGES[index]
    @perm_counter = DEATH_COUNTER[index]
  end

  def decrement_death
    if @perm_counter == 0
      index = [DEATH_PERCENTAGES.index(@perm_chance) - 1, 0].max
      @perm_chance = DEATH_PERCENTAGES[index]
      @perm_counter = DEATH_COUNTER[index]
    else
      @perm_counter -= 1
    end
  end

  def turn_off_nested_callbacks
    ProjectContribution.skip_callback(:create, :before, :invest_talent)
  end

  def turn_on_nested_callbacks
    ProjectContribution.set_callback(:create, :before, :invest_talent)
  end

  def open_bankaccount
    self.bank_accounts.create()
  end

  def display_name
    "#{self.name}"
  end

end
