class Referral < ActiveRecord::Base
  has_paper_trail
  belongs_to :referred_user, class_name: "User", inverse_of: :referral
  belongs_to :referring_user, class_name: "User", inverse_of: :referral

  validate :paid_4_events_before_claiming?, if: Proc.new { |bt| bt.event_claimed.present? }
  validates :referred_user, presence: true, uniqueness: true

  def paid_4_events_before_claiming?
    self.referred_user.paid_events >= 4
  end

end