class BonusExperience < ApplicationRecord
  belongs_to :character

  scope :newest, -> { order(date_awarded: :desc) }
  scope :oldest, -> { order(date_awarded: :asc) }
end
