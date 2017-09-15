class SpecialEffect < ApplicationRecord
  belongs_to :character

  scope :active, -> { where(expiration: DateTime.current..100.years.from_now)
                      .or(SpecialEffect.where(expiration: nil)) }
end