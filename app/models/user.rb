class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :omniauthable,
         omniauth_providers: [:facebook, :developer]
  has_many :characters, inverse_of: :user

  has_many  :downstream_referrals,  class_name: "Referral",         foreign_key: :sponsor_id
  has_many  :referred_users,        through: :downstream_referrals, source: :referred_user

  has_one   :upstream_referral,     class_name: "Referral",         foreign_key: :referred_user_id
  has_one   :sponsor,               through: :upstream_referral,    source: :sponsor

  scope :latest,      -> { order(updated_at: :desc) }
  scope :unsponsored, -> { User.where.not(id: Referral.all.map { |r| r.referred_user.id } ).order(name: :asc) }

  attr_accessor :options_confirm, :options_skip_confirm

  accepts_nested_attributes_for :upstream_referral, allow_destroy: true
  accepts_nested_attributes_for :downstream_referrals, allow_destroy: true

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).or(where(email: auth.info.email)).first_or_initialize do |user|
      user.email = user.email || auth.info.email
      user.password = user.password || Devise.friendly_token[0,20]
      user.name = user.name || auth.info.name
    end
    user.update(provider: auth.provider, uid: auth.uid) if user.persisted?
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.provider = 'facebook'
        user.uid = data['id']
        user.email = data["email"] if user.email.blank?
        user.name = data["name"] if user.name.blank?
      end
    end
  end

  # def password_match?
  #   self.errors[:password] << "can't be blank" if password.blank?
  #   self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
  #   self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
  #   password == password_confirmation && !password.blank?
  # end

  def played_events
    self.characters.reduce(Event.none) do |events, c|
      c.character_events.map { |ce| events << ce.event }
    end
  end

  def paid_events
    self.characters.reduce(0) do |sum, c|
      sum += c.character_events.where(paid: true).count
    end
  end

  def display_name
    "#{self.name} (#{self.email})"
  end

  def retirement_xp?
    self.std_retirement_xp_pool > 0 || self.leg_retirement_xp_pool > 0
  end

  def award_retirement_xp
    leg_amount = 0 # No more than 20
    std_amount = 0 # No more than 10

    # Remove no more than 20 XP from Leg
    if self.leg_retirement_xp_pool > 0
      leg_amount = [20, self.leg_retirement_xp_pool].min
      self.update(leg_retirement_xp_pool: (self.leg_retirement_xp_pool - leg_amount))
    end

    # Remove no more than 10 XP from Std
    if leg_amount < 10
      if self.std_retirement_xp_pool > 0
        std_amount = [10, self.std_retirement_xp_pool].min
        self.update(std_retirement_xp_pool: (self.std_retirement_xp_pool - std_amount))
      end
    end

    (leg_amount + std_amount)
  end
end
