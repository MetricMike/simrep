class CharacterOrigin < ActiveRecord::Base
  belongs_to :character
  belongs_to :origin
end
