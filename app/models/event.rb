class Event < ActiveRecord::Base
  has_paper_trail
  has_many :characters, -> { distinct }, through: :character_events, inverse_of: :events
  has_many :character_events, inverse_of: :event

  default_scope { order(weekend: :desc) }

  validates :campaign, presence: true
  validates :weekend, presence: true
  validates :play_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :clean_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def display_name
    "#{self.campaign} - #{self.weekend}"
  end
end
