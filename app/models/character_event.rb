class CharacterEvent < ActiveRecord::Base
  has_paper_trail
  belongs_to :character
  belongs_to :event
  
  accepts_nested_attributes_for :character, :event
end
