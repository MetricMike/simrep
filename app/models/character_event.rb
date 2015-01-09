class CharacterEvent < ActiveRecord::Base
  belongs_to :character
  belongs_to :event
  
  accepts_nested_attributes_for :character, :event
end
