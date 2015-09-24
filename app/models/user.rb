class User < ActiveRecord::Base
  has_paper_trail
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
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

  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

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
end
