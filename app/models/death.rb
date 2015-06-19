class Death < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :deaths

  validates :description, :physical, :roleplay, :date, presence: true

  after_create :record_death, if: :affects_perm_chance?

  def events_since
    current_character = Character.find(self.character_id)
    current_character.events.where(weekend: self.date..DateTime.now).count
  end

  def affects_perm_chance=(bool)
    @affects_perm_chance = bool
  end

  def affects_perm_chance?
    @affects_perm_chance ||= true
  end

  def record_death
    current_character = Character.find(self.character_id)
    current_character.increment_death
    current_character.save
  end

  def display_name
    "#{self.character}'s Death on #{self.date} - #{self.description}"
  end
end
