class GroupMembership < ApplicationRecord
  belongs_to :member, class_name: 'Character', foreign_key: 'member_id', inverse_of: :group_memberships
  belongs_to :group, inverse_of: :group_memberships
end
