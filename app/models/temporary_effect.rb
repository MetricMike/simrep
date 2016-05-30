class TemporaryEffect < ApplicationRecord
  belongs_to :character

  validates_presence_of :attr
end