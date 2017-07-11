class Group < ApplicationRecord
  has_many :group_memberships
  has_many :members, through: :group_memberships, class_name: 'Character'
  has_many :group_bank_accounts, inverse_of: :group

  def display_name
    self.try(:name) || ""
  end
end
