class Talent < ActiveRecord::Base
  has_paper_trail
  RANKS = ["Untrained", "Apprentice", "Journeyman", "Master", "Grandmaster"]
  GROUPS = ["Connection", "Scholarship", "Profession", "Craft", "Trick", "General", "Custom"]

  belongs_to :character, inverse_of: :talents

  validates :name, presence: true
  validates :spec, exclusion: { in: [nil] }
  validates :group, inclusion: {in: GROUPS}
  validates :value, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :investment_limit, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  def rank
    @rank
    if self.spec
      case self.value
      when 0..4 then @rank = RANKS[0]
      when 5..14 then @rank = RANKS[2]
      when 15..100 then @rank = RANKS[3]
      end
    else
      case self.value
      when 0..1 then @rank = RANKS[0]
      when 2..6 then @rank = RANKS[1]
      when 7..26 then @rank = RANKS[2]
      when 27..58 then @rank = RANKS[3]
      when 59..200 then @rank = RANKS[4]
      end
    end
  end

  def invest(amt, expend_timeunits=true)
    allowed_amt = [amt, self.investment_limit].min
    self.value += allowed_amt
    self.investment_limit -= allowed_amt
    (self.character.unused_talents -= allowed_amt && self.character.save) if expend_timeunits
    self.save
  end

  def friendly_name
    "#{self.rank} | #{self.group}: #{self.name}"
  end
end
