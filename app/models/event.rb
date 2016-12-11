class Event < ApplicationRecord
  has_many :characters, through: :character_events, inverse_of: :events
  has_many :character_events, inverse_of: :event

  belongs_to :chapter, inverse_of: :events

  scope :newest, -> { order(weekend: :desc) }
  scope :oldest, -> { order(weekend: :asc) }

  validates :campaign, presence: true
  validates :weekend, presence: true
  validates :play_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :clean_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def paying_characters
    characters.where(character_events: { paid: true }) - new_characters
  end

  def new_characters
    characters.first_event
  end

  def event_willpower
    self.base_willpower || 1
  end

  def display_name
    "#{self.campaign} - #{self.weekend}"
  end
end
