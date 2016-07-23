class Group < ApplicationRecord
  has_many :members, through: :group_memberships, inverse_of: :groups
  has_many :group_memberships
  has_many :group_bank_accounts
end
