class Group < ApplicationRecord
  belongs_to :member
  belongs_to :group_bank_account
end
