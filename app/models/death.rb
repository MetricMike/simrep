class Death < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :death

  validates :description, :physical, :roleplay, :date, presence: true
  validates :perm_chance, exclusion: { in: [nil] }

  def perm_chance=(bool)
    @perm_chance = bool == "yes" ? true : false
  end

  def perm_chance
    @perm_chance ? "yes" : "no"
  end
end
