class NpcShift < ActiveRecord::Base
  has_paper_trail
  belongs_to :character_event, inverse_of: :npc_shifts

  MAX_MONEY = Money.new(2500, :vmk)
  MAX_TIMEUNITS = 3

  MONEY_CLEAN = 2
  MONEY_DIRTY = 1

  TIMEUNITS_TIERS_HOURS = [1, 3, 6]

  def open_shift(opening=Time.now.utc)
    self.update(opening: opening)
  end

  def close_shift(closing=Time.now.utc)
    self.update(closing: closing)
  end

  def max_hours
    if self.opening and self.closing
      @max_hours = (self.closing - self.opening).round.to_i / (60*60)
    else
      @max_hours = 0
    end
  end

  def assign_hours(money=0, time=0)
    if money+time <= self.max_hours
      self.update(hours_to_money: money, hours_to_time: time)
    else
      self.errors.add(:base, "Tried to assign #{money+time} hours, but only earned #{self.max_hours}.")
      return false
    end
  end

  def verify
    self.update(verified: true)

    if self.hours_to_money
      pay_rate = self.hours_to_money * (self.dirty? ? MONEY_CLEAN + MONEY_DIRTY : MONEY_CLEAN)
      self.character_event.accumulated_npc_money += Money.new(pay_rate*100, :vmk) if pay_rate > 0
      self.character_event.save
    end
    if self.hours_to_time
      time_rate = TIMEUNITS_TIERS_HOURS.rindex { |i| self.hours_to_time >= i }
      self.character_event.character.unused_talents += time_rate
      self.character_event.character.save
    end
  end

  def display_name
    "#{self.character_event.character.display_name}'s #{self.character_event.event.display_name} Shift from #{self.opening} to #{self.closing}"
  end
end