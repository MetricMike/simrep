class User < ActiveRecord::Base
  has_paper_trail
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :characters, inverse_of: :user

  has_many  :downstream_referrals,  class_name: "Referral",         foreign_key: :sponsor_id
  has_many  :referred_users,        through: :downstream_referrals, source: :sponsor

  has_one   :upstream_referral,     class_name: "Referral",         foreign_key: :referred_user_id
  has_one   :sponsor,               through: :upstream_referral,    source: :referred_user

  scope :latest, -> { order(updated_at: :desc) }

  attr_accessor :options_confirm, :options_skip_confirm

  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
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
