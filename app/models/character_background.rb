class CharacterBackground < ActiveRecord::Base
  belongs_to :character
  belongs_to :background
end
