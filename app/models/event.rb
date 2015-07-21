class Event < ActiveRecord::Base
  has_paper_trail
  has_many :characters, -> { distinct }, through: :character_events, inverse_of: :events
  has_many :character_events, inverse_of: :event

  default_scope { order(weekend: :desc) }

  validates :campaign, presence: true
  validates :weekend, presence: true
  validates :play_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :clean_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def new_characters
    @new_characters = []
    self.characters.map do |c|
      unless c.try(:user)
        @new_characters << c
      else
        @new_characters << c if (c == c.user.characters.order(created_at: :asc).try(:first) && self == c.first_event)
      end
    end
    return @new_characters
  end

  def display_name
    "#{self.campaign} - #{self.weekend}"
  end
end
