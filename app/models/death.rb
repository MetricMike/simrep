class Death < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :deaths

  validates :description, :physical, :roleplay, :date, presence: true
  validates :perm_chance, inclusion: { in: [true, false] }
end
