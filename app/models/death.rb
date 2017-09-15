class Death < ApplicationRecord
  DEATH_PERCENTAGES = [0, 10, 30, 60, 90]
  DEATH_COUNTER = [0, 3, 2, 1, 0]
  belongs_to :character, inverse_of: :deaths

  delegate :character_events, to: :character
  alias_method :events, :character_events

  scope :latest,          ->              { order(weekend: :desc) }
  scope :affects_perm,    ->              { where(countable: true) }
  scope :between_events,  ->(last, first) { where(weekend: first..last) }

  validates :description, :physical, :roleplay, :weekend, presence: true

  def events_since(weekend = Date.today)
    # The event of the death doesn't count, but the current event does
    # MICHAEL DO NOT CHANGE THIS AGAIN, OTHERWISE YOU WILL HAVE PCs WHO THINK THEY
    # HAVE A HIGHER DEATH THAN THEY REALLY DO
    self.events.paid.after(self.weekend+5.days).before(weekend).count
  end

  def previous_death
    self.character.deaths.where('weekend <= ?', self.weekend).latest.second
  end

  def display_name
    "#{self.character.name}'s Death on #{self.weekend} - #{self.description}"
  end
end
