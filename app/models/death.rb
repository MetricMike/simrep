class Death < ApplicationRecord
  DEATH_PERCENTAGES = [0, 10, 30, 60, 90]
  DEATH_COUNTER = [0, 3, 2, 1, 0]
  belongs_to :character, inverse_of: :deaths

  delegate :perm_chance, :perm_counter, to: :character

  delegate :character_events, to: :character
  alias_method :events, :character_events

  scope :latest,        -> { order(weekend: :desc) }
  scope :affects_perm,  -> { where(countable: true) }
  scope :previous,      -> { where('updated_at < ?', self.updated_at).latest }

  validates :description, :physical, :roleplay, :weekend, presence: true

  def events_since(weekend = Date.today)
    # The event of the death doesn't count, but the current event does
    # MICHAEL DO NOT CHANGE THIS AGAIN, OTHERWISE YOU WILL HAVE PCs WHO THINK THEY
    # HAVE A HIGHER DEATH THAN THEY REALLY DO
    self.events.paid.after(self.weekend+5.days).before(weekend).count
  end

  def affects_perm_chance?
    return self.events_since <= 3 unless previous_death
    # How many events since this death?
      # 3? Yes.
      # 2? Is there another death in the last 2+3? Yes.
      # 1? Is there another death in the last
    # index = DEATH_PERCENTAGES.index(self.perm_chance)
    # previous_death.events_since + self.events_since
    # is the previous death within the counter?
    # 90 0
    # 60 1
    # 30 2
    # 10 3
  end

  def previous_death
    self.characters.death.previous.first
  end

  def display_name
    "#{self.character.name}'s Death on #{self.weekend} - #{self.description}"
  end
end
