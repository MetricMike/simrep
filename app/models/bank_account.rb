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

  before_create :set_default_currency
  after_create  :initial_deposit, unless: :not_my_first_account

  AVAIL_CURRENCIES = {
    Chapter::BASTION    => [Money::Currency.find(:vmk), Money::Currency.find(:sgd)],
    Chapter::HOLURHEIM  => [Money::Currency.find(:hkr)]
  }

  def not_my_first_account
    return false if self.type == "GroupBankAccount"
    return false if owner.bank_accounts.where(chapter: chapter).count > 0
  end

  def currencies
    @currencies ||= AVAIL_CURRENCIES[chapter]
  end

  def initial_deposit
    return unless not_my_first_account
    BankTransaction.create(to_account: self, funds_cents: 500, memo: "Initial deposit.")
  end

  def set_default_currency
    currency = chapter == Chapter::HOLURHEIM ? :hkr : :vmk
  end

  def does_not_exceed_credit
    if balance < (Money.new(0, balance_currency) - self.line_of_credit)
      errors.add(:balance, "Insufficient funds in account for transaction")
    end
  end

  def transactions
    @transactions ||= outgoing_transactions.union(incoming_transactions)
                    .includes(from_account: :owner, to_account: :owner)
                    .latest
  end

  def last_transaction
    @transactions.last if @transactions
  end

  def items
    @items ||= outgoing_items.union(incoming_items)
                .includes(from_account: :owner, to_account: :owner)
                .latest
  end

  def last_item
    @items.last if @items
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
