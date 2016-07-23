class GroupMembership < ApplicationRecord
  belongs_to :member, class_name: 'Character'
  belongs_to :group
end
