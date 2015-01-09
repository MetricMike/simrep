class Event < ActiveRecord::Base
  has_paper_trail
  has_many :characters, through: :character_events
  has_many :character_events
  
  validates :campaign, presence: true
  validates :weekend, presence: true
  validates :play_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :clean_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
