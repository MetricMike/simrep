class CharacterEvent < ActiveRecord::Base
  has_paper_trail
  belongs_to :character, inverse_of: :event
  belongs_to :event, inverse_of: :character

  accepts_nested_attributes_for :character, :event
end
