class Character < ApplicationRecord
  RACES = ["Human", "Elf", "Dwarf", "Gnome", "Ent", "Custom"]
  CULTURES = ["Cryogen", "Venthos", "Sengra", "Illumen/Lumiend", "Shaiden/Om'Oihanna", "Illugar/Unan Gens", "Shaigar/Alkon'Gol", "Hella", "Thundermark", "Minor", "Custom"]
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
  scope :newest, -> { order(updated_at: :desc) }
  scope :no_user, -> { where(user: nil) }
  scope :only_user, -> { where(user: User.single_character) }
  scope :only_character, -> { no_user.or(Character.only_user) }
  scope :first_event, -> { Character.where(id: CharacterEvent.group(:character_id).count.select {|_,v| v == 1 }.keys.uniq) }
  scope :for_current_chapter, ->(chapter) { where(chapter_id: chapter['id']) }
  scope :recently_played, ->(from=6.months.ago) { includes(:events)
                                                  .where('events.weekend': from..Time.current)
                                                  .references(:events) }

  belongs_to :user, inverse_of: :characters
  belongs_to :chapter, inverse_of: :characters

  has_many :character_backgrounds, ->{ includes(:background) }, inverse_of: :character, dependent: :destroy
  has_many :character_origins, ->{ includes(:origin) }, inverse_of: :character, dependent: :destroy
  has_many :character_birthrights, ->{ includes(:birthright) }, inverse_of: :character, dependent: :destroy
  has_many :character_skills, ->{ includes(:skill) }, inverse_of: :character, dependent: :destroy
  has_many :character_perks, ->{ includes(:perk) }, inverse_of: :character, dependent: :destroy
  has_many :character_events, inverse_of: :character, dependent: :destroy

  has_many :project_contributions, inverse_of: :character, dependent: :destroy
  has_many :group_memberships, foreign_key: 'member_id', dependent: :destroy

  has_many :backgrounds, through: :character_backgrounds, inverse_of: :characters, dependent: :destroy
  has_many :origins, through: :character_origins, inverse_of: :characters, dependent: :destroy
  has_many :birthrights, through: :character_birthrights, inverse_of: :characters, dependent: :destroy
  has_many :skills, through: :character_skills, inverse_of: :characters, dependent: :destroy
  has_many :perks, through: :character_perks, inverse_of: :characters, dependent: :destroy
  has_many :events, through: :character_events, inverse_of: :characters, dependent: :destroy
  has_many :projects, through: :project_contributions, inverse_of: :characters, dependent: :destroy
  has_many :groups, through: :group_memberships, dependent: :destroy

  has_many :talents, inverse_of: :character, dependent: :destroy
  has_many :deaths, inverse_of: :character, dependent: :destroy
  has_many :bank_accounts, class_name: 'PersonalBankAccount', foreign_key: :owner_id, dependent: :destroy
  has_many :crafting_points, dependent: :destroy

  has_many :special_effects, inverse_of: :character, dependent: :destroy
  has_many :bonus_experiences, inverse_of: :character, dependent: :destroy

  accepts_nested_attributes_for :character_backgrounds, :character_origins, :character_birthrights, :character_skills,
                                :character_perks, :character_events, :bank_accounts,
                                :crafting_points, :group_memberships, allow_destroy: true
  accepts_nested_attributes_for :project_contributions, :talents, :deaths, :birthrights, :origins, :backgrounds,
                                :events, :skills, :perks, :special_effects, :bonus_experiences,
                                allow_destroy: true

  validates :name, presence: true
  validates :race, inclusion: { in: RACES }
  validates :culture, inclusion: { in: CULTURES }
  validates :costume, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 4 }
  validates :unused_talents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_create :assign_chapter, if: Proc.new { self.chapter.blank? }
  after_create :award_starting_bonus_xp
  after_create :open_bankaccount

  before_save :update_cached_xp

  def update_cached_xp
    self.cached_experience = self.experience
  end

  def assign_chapter
    self.chapter = Event.last.try(:chapter)
  end

  def level
    @level = EXP_CHART.rindex { |i| self.experience >= i }
  end

  def exp_to_next
    @exp_to_next = EXP_CHART[self.level + 1] - self.experience
  end

  def last_event
    @last_event = self.events.newest.try(:first)
  end

  def third_last_event(index_event=self.last_event)
    return nil if index_event.nil?
    all_events = self.events.where('weekend <= ?', index_event.weekend).newest
    num_events = all_events.count
    @third_last_event = num_events >= 3 ? all_events.third : all_events.last
  end

  def experience
    @experience ||= begin
      pay_xp = self.character_events.paid_with_xp.pluck('events.play_exp').reduce(0, :+)
      clean_xp = self.character_events.cleaned_with_xp.pluck('events.clean_exp').reduce(0, :+)
      background_xp = (self.backgrounds.find { |b| b.name.start_with?("Experienced") }) ? 20 : 0
      bonus_xp = (self.bonus_experiences.pluck(:amount).reduce(0, :+))
      BASE_XP + pay_xp + clean_xp + background_xp + bonus_xp
    end
  end

  def living_events
    self.dead? ? self.character_events.before(last_living_breath) : self.character_events
  end

  def dead_events
    self.character_events - living_events
  end

  def dead?
    self.origins.where('name ilike ?', '%Ghost%').try(:first).present? ||
      self.last_living_breath.present?
  end

  def transformed?
    self.backgrounds.where('name ilike ?', '%High Arcane%').try(:first).present?
  end

  def transformed_at
    str_weekend = self.backgrounds_where('name ilike ?', '%High Arcane%').detail
    Event.where(weekend: Date.str_weekend)
  end

  def last_living_breath
    self.deaths.where('description ilike ?', '%PERMED%').try(:last).try(:weekend)
  end

  def self.skill_points_for_experience(exp=BASE_XP)
    SKILL_CHART[ EXP_CHART.rindex{ |i| exp >= i } ]
  end

  def skill_points_used
    @skill_points_used = self.skills.reduce(0) { |sum, el| sum + el.cost }
  end

  def skill_points_total
    @skill_points_total = SKILL_CHART[level] * skillpoint_multiplier
  end

  def skill_points_unspent
    skill_points_total - skill_points_used
  end

  def skillpoint_multiplier
    return 3 if self.perks.find { |p| p.name =~ /proto revelation/i }
    return 3 if self.origins.find { |o| o.name =~ /proto revelation/i }
    return 2 if self.birthrights.find { |o| o.name =~ /proto form/i }
    return 2 if self.origins.find { |o| o.name =~ /proto/i }
    return 1
  end

  def perk_points_used
    @perk_points_used = self.perks.reduce(0) { |sum, el| sum + el.cost }
  end

  def perk_points_total
    added_perks = self.skills.select{ |s| s.name.downcase == "added perks" }.pluck(:cost).reduce(0, :+) * self.costume
    @perk_points_total = self.costume + added_perks +
                          (self.backgrounds.find { |b| b.name.start_with?("Paragon") } ? 4 : 0)
  end

  def perk_points_unspent
    perk_points_total - perk_points_used
  end

  def talent_points_unspent
    unused_talents
  end

  def invest_in_project(amt, talent=nil)
    self.unused_talents -= amt
    self.talents.find(talent).invest(amt, false) if talent.present?
    self.save
  end

  def investment_max
    return 6 if self.origins.find { |o| o.name =~ /proto revelation/i }
    return 4
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
    award_paid(attendance, paid, override)
    award_cleaned(attendance, cleaned, check_coupon, override)
    award_retired(event_id, paid)
  end

  def award_retired(event_id, paid)
    return unless paid
    return if self.bonus_experiences.where(reason: "Retirement XP", date_awarded: Event.find(event_id).weekend.in_time_zone).present?
    if self.user.retirement_xp?
      self.bonus_experiences.create(reason: "Retirement XP",
                                    date_awarded: Event.find(event_id).weekend.in_time_zone,
                                    amount: self.user.deduct_retirement_xp)
    end
  end

  def award_paid(char_event, bool=false, override=false)
    return if (char_event.paid? or !override.nil?)
    char_event.update(paid: bool || false)
  end

  def award_cleaned(char_event, bool=false, check_coupon=false, override=false)
    return if (char_event.cleaned? or !override.nil?)
    if (!bool.nil? and check_coupon)
      clean_coupon = Event.where(id: self.user.free_cleaning_event_id).try(:first)
      if (clean_coupon.nil? || clean_coupon.weekend >= 1.year.ago)
        self.user.update(free_cleaning_event_id: char_event.event_id)
        char_event.update(cleaned: true) and return
      end
    end
    char_event.update(cleaned: bool || false)
  end

  def active_deaths(index_last=self.third_last_event, index_first=self.last_event)
    self.deaths.affects_perm.between_events(
      index_last.weekend, index_first.weekend)
  end

  def perm_chance(index_last=self.third_last_event, index_first=self.last_event)
    return 0 if index_first.nil?
    DEATH_PERCENTAGES[active_deaths(index_last, index_first).count]
  end

  def perm_counter(index_last=self.third_last_event, index_first=self.last_event)
    return 0 if index_first.nil?
    num_events_since = active_deaths(index_last, index_first).last.try(:events_since) || 3
    [3 - num_events_since, 0].max
  end

  def historical_perm_stats
    last_twelve_events = self.events.newest.limit(12)
    max_events = last_twelve_events.count
    historical_perm_chances = {}
    last_twelve_events.each_with_index.map do |event, i|
      plus_three_events = [i+3, max_events-1].min
      historical_perm_chances[event.weekend] = self.perm_chance(event, last_twelve_events[plus_three_events])
    end
    historical_perm_chances
  end

  def turn_off_nested_callbacks
    ProjectContribution.skip_callback(:create, :before, :invest_talent)
  end

  def turn_on_nested_callbacks
    ProjectContribution.set_callback(:create, :before, :invest_talent)
  end

  def award_starting_bonus_xp
    return if self.bonus_experiences.where(reason: "Chapter Starting XP").present?
    return if self.chapter.default_xp == Character::BASE_XP
    self.bonus_experiences.create(reason: "Chapter Starting XP",
                                  date_awarded: self.starting_event,
                                  amount: self.chapter.default_xp - Character::BASE_XP)
    self.update_cached_xp
  end

  def starting_event
    self.events.try(:first).try(:weekend) || Time.current
  end

  def open_bankaccount
    assign_chapter if chapter.blank?
    return if primary_bank_account.present?
    bank_accounts.create(chapter: chapter, balance_currency: :vmk, line_of_credit_currency: :vmk)
  end

  def default_currency
    chapter == Chapter.find_by(name: "Holurheim") ? :hkr : :vmk
  end

  def primary_bank_account
    bank_accounts.where(chapter: chapter).try(:first)
  end

  def display_name
    "#{self.name}"
  end

  def calc_willpower
    @willpower = self.last_event.try(:event_willpower) || 1
    if willpower_modifiers = self.special_effects.where(attr: 'willpower').where('expiration > ?', Time.current)
      @willpower += willpower_modifiers.reduce(0) { |sum, eff| sum + eff.modifier }
    end
    @willpower
  end

  def retire(type=:standard)
    case type.to_sym
    when :standard
      self.update(retired: true)
      self.user.update(std_retirement_xp_pool: (self.user.std_retirement_xp_pool || 0) + (self.experience - 31)/2)
    when :legacy
      self.update(retired: true)
      self.user.update(leg_retirement_xp_pool: (self.user.leg_retirement_xp_pool || 0) + (self.experience - 31)/2)
    when :high_arcane
      # What happens to previous experience? Does it no longer count or do you level REALLY slowly?
      self.user.update(leg_retirement_xp_pool: (self.user.leg_retirement_xp_pool || 0) + (self.experience - 31)/2)
    when :ghost
      self.user.update(leg_retirement_xp_pool: (self.user.leg_retirement_xp_pool || 0) + (self.experience - 31)/2)
    else
      Rails.logger.info "I don't know how to retire #{type}.\n" \
                        "It shouldn't have been possible to reach this state.\n" \
                        "You've summoned a Kiltrick.\n" \
                        "Good job."
      self.errors[:base] << "Unknown retirement type #{type}"
      return false
    end
  end

end
