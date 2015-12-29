class CharacterEvent < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :character_events
  belongs_to :event, inverse_of: :character_events
  has_many :npc_shifts, inverse_of: :character_event

  monetize :accumulated_npc_money_cents

  accepts_nested_attributes_for :character, :event, allow_destroy: true

  scope :paid,            ->          { where(paid: true) }
  scope :paid_with_xp,    ->          { includes(:event).where(paid: true) }
  scope :cleaned,         ->          { where(cleaned: true) }
  scope :cleaned_with_xp, ->          { includes(:event).where(cleaned: true) }
  scope :after,           ->(weekend) { includes(:event).where('events.weekend >= ?', weekend).references(:event) }
  scope :before,          ->(weekend) { includes(:event).where('events.weekend <= ?', weekend).references(:event) }

  def give_attendance_awards
    current_character = Character.find(self.character_id)
    if self.paid && !self.awarded?
      current_character.talents.each { |talent| talent.investment_limit = [talent.investment_limit+2, 4].min; talent.save }
      current_character.unused_talents += 2
      current_character.decrement_death
      current_character.save
      self.update(awarded: true)
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