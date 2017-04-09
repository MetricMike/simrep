class BankAccount < ApplicationRecord
  belongs_to :chapter, inverse_of: :bank_accounts

  has_many :outgoing_transactions, class_name: 'BankTransaction', foreign_key: :from_account_id, dependent: :destroy
  has_many :incoming_transactions, class_name: 'BankTransaction', foreign_key: :to_account_id, dependent: :destroy
  has_many :outgoing_items, class_name: 'BankItem', foreign_key: :from_account_id, dependent: :destroy
  has_many :incoming_items, class_name: 'BankItem', foreign_key: :to_account_id, dependent: :destroy

  monetize :balance_cents, with_model_currency: :balance_currency
  monetize :line_of_credit_cents, with_model_currency: :line_of_credit_currency

  scope :personal_accounts, -> { where(type: 'PersonalBankAccount') }
  scope :group_accounts, -> { where(type: 'GroupBankAccount') }

  validate :does_not_exceed_credit
  validates_presence_of :chapter

  before_validation(on: :create) do
    currency = chapter == Chapter.find_by(name: "Holurheim") ? :hkr : :vmk
    balance_currency = currency
    line_of_credit_currency = currency
  end

  def self.inherited(base)
    super

    def base.model_name
      superclass.model_name
    end
  end

  def not_my_first_account
    return false if self.type == "GroupBankAccount"
    return false if PersonalBankAccount.where(owner_id: self.owner_id).count > 0
  end

  def currencies
    @currencies ||= chapter.currencies
  end

  def does_not_exceed_credit
    if balance < (Money.new(0, balance_currency) - self.line_of_credit)
      errors.add(:balance, "Insufficient funds in account for transaction")
    end
  end

  def transactions
    outgoing_transactions.union(incoming_transactions)
      .includes(from_account: :owner, to_account: :owner)
      .latest
  end

  def items
    outgoing_items.union(incoming_items)
      .includes(from_account: :owner, to_account: :owner)
      .latest
  end

  def withdraw(amt, force=false)
    old_balance = self.balance
    self.balance -= amt
    self.save(validate: !force)
  end

  def deposit(amt)
    self.balance += amt
    self.save
  end
end
