class CharacterOrigin < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :character_origins
  belongs_to :origin, inverse_of: :character_origins

  accepts_nested_attributes_for :origin, allow_destroy: true
end
