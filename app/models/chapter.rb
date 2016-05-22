class Chapter < ApplicationRecord
  include ConstantCache
  cache_constants

  has_many :characters, inverse_of: :chapter
  has_many :bank_accounts, inverse_of: :chapter
  has_many :events, inverse_of: :chapter
end
