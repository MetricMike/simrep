class CharacterEvent < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :character_events
  belongs_to :event, inverse_of: :character_events
  has_many :npc_shifts, inverse_of: :character_event

  monetize :accumulated_npc_money_cents

  accepts_nested_attributes_for :character, :event, allow_destroy: true

  def give_attendance_awards
    current_character = Character.find(self.character_id)
    if self.paid && self.awarded == false
      current_character.talents.each { |talent| talent.investment_limit = [talent.investment_limit+2, 4].min; talent.save }
      current_character.unused_talents += 2
      current_character.decrement_death
      self.pay_for_npcing if (self.accumulated_npc_money > 0 || self.accumulated_npc_timeunits_totalhours > 0)
      current_character.save
      self.update(awarded: true)
    end
  end

  def pay_for_npcing
    if (self.accumulated_npc_money > 0) && self.paid?
      BankTransaction.create(to_account_id: self.character.id,
                             funds: [self.accumulated_npc_money, NpcShift::MAX_MONEY].min,
                             memo: "Bank Work for #{self.event.weekend}")
    end

    if (self.accumulated_npc_timeunits_totalhours > 0) && self.paid?
      self.character.unused_talents += [self.accumulated_npc_timeunits_totalhours, NpcShift::MAX_TIMEUNITS].min
      self.character.save
    end
  end

  def total_npc_money
    @total_npc_money = self.accumulated_npc_money
  end

  def total_npc_timeunits_hours
    @total_npc_timeunits_hours = self.accumulated_npc_timeunits_totalhours
  end

  def display_name
    "#{self.character.display_name}'s #{self.event.display_name}"
  end
end