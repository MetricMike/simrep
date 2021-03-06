class Referral < ApplicationRecord
  belongs_to :sponsor,        class_name: "User",   inverse_of: :downstream_referrals
  belongs_to :referred_user,  class_name: "User",   inverse_of: :upstream_referral
  belongs_to :event_claimed,  class_name: "Event",  required: false

  validate :paid_4_events_before_claiming?, if: Proc.new { |r| r.event_claimed.present? }
  validates :referred_user, presence: true, uniqueness: true

  def paid_4_events_before_claiming?
    self.referred_user.paid_events >= 4
  end

end
