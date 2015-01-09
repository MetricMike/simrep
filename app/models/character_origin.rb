class CharacterOrigin < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :origin
  belongs_to :origin, inverse_of: :character

  accepts_nested_attributes_for :origin
end
