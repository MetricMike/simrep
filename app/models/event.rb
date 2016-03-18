class Event < ActiveRecord::Base
  has_paper_trail
  has_many :characters, through: :character_events, inverse_of: :events
  has_many :character_events, inverse_of: :event

  scope :newest, -> { order(weekend: :desc) }
  scope :oldest, -> { order(weekend: :asc) }

  validates :campaign, presence: true
  validates :weekend, presence: true
  validates :play_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :clean_exp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def paying_characters
    @paying_characters = self.characters.references(:character_events).where(character_events: { paid: true })
    @paying_characters -= self.new_characters
  end

  def new_characters
    @new_characters = []
    self.characters.map do |c|
      flag = true
      if c.user
        if c != c.user.characters.by_name_asc.try(:first)
          flag = false
        end
      end

      if (self == c.first_event && flag)
        @new_characters << c
      end
    end
    return @new_characters
  end

  def event_willpower
    self.base_willpower || 1
  end

  def display_name
    "#{self.campaign} - #{self.weekend}"
  end
end
