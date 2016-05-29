class CharacterEvent < ApplicationRecord
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
  scope :order_for_select,->          { includes(:character, :event).all
                                        .order('events.weekend DESC, characters.name')
                                        .references(:events, :characters) }

  def give_attendance_awards
    if self.paid? && !self.awarded?
      ActiveRecord::Base.transaction do
        self.character.talents.each { |t| t.update(investment_limit: [t.investment_limit+2, self.character.investment_max].min) }
        self.character.update(unused_talents: self.character.unused_talents+num_timeunits_earned)
        self.update(awarded: true)
      end
    end
  end

  def revert_attendance_awards
    if !self.paid? && self.awarded?
      ActiveRecord::Base.transaction do
        self.character.talents.each { |t| t.update(investment_limit: t.investment_limit-2)}
        self.character.update(unused_talents: self.character.unused_talents-num_timeunits_earned)
        self.update(awarded: false)
      end
    end
  end

  def num_timeunits_earned
    self.character.dead? ? 5 : 2
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