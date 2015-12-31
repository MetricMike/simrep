class Death < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :deaths

  delegate :character_events, to: :character
  alias_method :events, :character_events

  scope :latest,    -> { order(weekend: :desc) }
  scope :countable, -> { where(countable: true) }

  validates :description, :physical, :roleplay, :weekend, presence: true

  def events_since(weekend = Date.today)
    # The event of the death doesn't count, but the current event does
    # MICHAEL DO NOT CHANGE THIS AGAIN, OTHERWISE YOU WILL HAVE PCs WHO THINK THEY
    # HAVE A HIGHER DEATH THAN THEY REALLY DO
    self.events.paid.after(self.weekend+5.days).before(weekend).count
  end

  def display_name
    "#{self.character}'s Death on #{self.weekend} - #{self.description}"
  end
end
