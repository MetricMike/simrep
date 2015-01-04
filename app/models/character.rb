class Character < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates :experience, presence: true, numericality: { only_integer: true, greater_than: 0 }
  default_scope -> { order(experience: :desc) }
end
