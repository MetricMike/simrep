class TemporaryEffect < ActiveRecord::Base
  has_paper_trail
  belongs_to :character

  validates_presence_of :attr
end