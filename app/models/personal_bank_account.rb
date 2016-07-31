class PersonalBankAccount < BankAccount
  belongs_to :owner, class_name: 'Character'
  validates_presence_of :owner

  delegate :name, to: :owner
  after_create  :initial_deposit, unless: :not_my_first_account

  def initial_deposit
    return if not_my_first_account
    BankTransaction.create(to_account: self, funds_cents: 500, funds_currency: balance_currency, memo: "Initial deposit.")
  end

  def display_name
    "#{self.owner.display_name} | #{self.chapter.name}"
  end
end
