class NpcShift < ActiveRecord::Base
  has_paper_trail
  belongs_to :character_event, inverse_of: :npc_shifts

  delegate :character, :event, :accumulated_npc_money, to: :character_event
  alias_method :etd_pay, :accumulated_npc_money

  MAX_MONEY = Money.new(2000, :vmk)
  PAY_MEMO_MSG = "Bank Work (Shift ##{self.id}) for #{self.event.weekend}."
  LIMIT_REACHED_MSG = "Bank Contract limits contractors to #{MAX_MONEY} per market day."

  MONEY_CLEAN = 2
  MONEY_DIRTY = 1

  validates_presence_of :character_event
  validate :disable_simultaneous_shifts

  def disable_simultaneous_shifts
    if another_already_opened?
      errors[:base] << "This character already has a shift open this event."
    end
  end

  def another_already_opened?
    NpcShift.where(character_event: self.event, closing: nil)
              .where.not(opening: nil)
              .count != 0
  end

  def open_shift(opening=Time.now.utc)
    return false if another_already_opened?
    self.update(opening: opening.floor_to(15.minutes))
  end

  def close_shift(closing=Time.now.utc)
    return false if self.opening == nil
    self.update(closing: closing.ceil_to(15.minutes))
    issue_awards_for_shift!
  end

  def money_paid?
    @money_paid = (self.hours_to_money > 0) ? self.money_paid : true
  end

  def unallocated_hours
    @unallocated_hours = self.max_hours - self.hours_to_money# - self.hours_to_time
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

  private

  def shift_length # in hours as a float so we can do partial payments
    (self.closing - self.opening).to_f / 60*60
  end

  def issue_awards_for_shift!
    pay_rate = (self.dirty? ? MONEY_CLEAN + MONEY_DIRTY : MONEY_CLEAN) * 100 # hourly
    gross_pay = Money.new(shift_length * pay_rate, :vmk)
    # Respect the per-event cap for payments
    etd_pay = self.character_event.accumulated_npc_money # event-to-date (like ytd)
    net_pay = [gross_pay, MAX_MONEY-etd_pay].min
    memo_msg = (net_pay > Money.new(0, :vmk)) ? PAY_MEMO_MSG : "#{PAY_MEMO_MSG}\n#{LIMIT_REACHED_MSG}"

    ActiveRecord::Base.transaction do
      self.character_event.update(accumulated_npc_money: (etd_pay+net_pay))
      BankTransaction.create!(to_account: BankAccount.find_by(owner: self.character),
                              funds: net_pay,
                              memo: memo_msg)
    end
  end

  def display_name
    "#{self.character_event.character.display_name}'s #{self.character_event.event.display_name} Shift from #{self.opening} to #{self.closing}"
  end
end