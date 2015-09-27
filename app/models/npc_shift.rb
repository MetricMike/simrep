class NpcShift < ActiveRecord::Base
  has_paper_trail
  belongs_to :character_event, inverse_of: :npc_shifts

  MAX_MONEY = Money.new(2000, :vmk)
  #MAX_TIMEUNITS = 3

  MONEY_CLEAN = 2
  MONEY_DIRTY = 1

  #TIMEUNITS_TIERS_HOURS = [1, 3, 6]

  def open_shift(opening=Time.now.utc)
    self.update(opening: opening)
  end

  def close_shift(closing=Time.now.utc)
    self.update(closing: closing)
  end

  def money_paid?
    @money_paid = (self.hours_to_money > 0) ? self.money_paid : true
  end

  # def time_paid?
  #   @time_paid = (self.hours_to_time > 0) ? self.time_paid : true
  # end

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

  def issue_awards_for_shift
    unless self.verified? && self.character_event.paid?
      self.errors.add(:base, "Cannot issue awards until \
                              shift times verified (currently: #{self.verified?}) and \
                              event paid for (currently: #{self.character_event.paid?})")
    else
      if (self.hours_to_money > 0) && !self.money_paid?
        # How much did they earn?
        pay_rate = (self.dirty? ? MONEY_CLEAN + MONEY_DIRTY : MONEY_CLEAN) * 100
        uncapped_payment = Money.new(self.hours_to_money * pay_rate, :vmk)
        # Respect the per-event cap for payments
        capped_payment = [uncapped_payment, MAX_MONEY-self.character_event.accumulated_npc_money].min

        if capped_payment > Money.new(0, :vmk)
          self.character_event.accumulated_npc_money += capped_payment
          BankTransaction.create(to_account: BankAccount.find_by(owner: self.character_event.character),
                               funds: capped_payment,
                               memo: "Bank Work (Shift ##{self.id}) for #{self.character_event.event.weekend}")
          self.character_event.save

          #Return unused hours if needed.
          if uncapped_payment != capped_payment
            overpayment = uncapped_payment - capped_payment
            unused_hours = overpayment.cents / pay_rate
            self.update(hours_to_money: self.hours_to_money-unused_hours)
          end
        end
        self.update(money_paid: true)
      end

      # if (self.hours_to_time > 0) && !self.time_paid?
      #   # How much did they earn?
      #   uncapped_time = TIMEUNITS_TIERS_HOURS.rindex { |i| self.hours_to_time >= i } + 1
      #   # Respect the per-event cap for payments
      #   capped_time = [MAX_TIMEUNITS-self.character_event.accumulated_npc_timeunits, uncapped_time].min

      #   if capped_time > 0
      #     self.character_event.accumulated_npc_timeunits += capped_time
      #     self.character_event.character.unused_talents += capped_time
      #     self.character_event.save && self.character_event.character.save
      #   end

      #   #Return unused hours if needed.
      #   if uncapped_time != capped_time
      #     overtime = uncapped_time - capped_time
      #     unused_hours = TIMEUNITS_TIERS_HOURS[overtime-1]
      #     self.update(hours_to_time: self.hours_to_time-unused_hours)
      #   end
      #   self.update(time_paid: true)
      # end
    end
  end

  def display_name
    "#{self.character_event.character.display_name}'s #{self.character_event.event.display_name} Shift from #{self.opening} to #{self.closing}"
  end
end