class BankAccount < ActiveRecord::Base
  belongs_to :owner, class_name: 'Character'
  has_many :outgoing_transactions, class_name: 'BankTransaction', foreign_key: :from_account_id, dependent: :destroy
  has_many :incoming_transactions, class_name: 'BankTransaction', foreign_key: :to_account_id, dependent: :destroy
  monetize :balance_cents, :line_of_credit_cents

  validate :does_not_exceed_credit, unless: :force?

  attr_accessor :force
  alias_method :force?, :force

  def does_not_exceed_credit
    if balance < (Money.new(0, 'VMK') - self.line_of_credit)
      errors.add(:balance, "Insufficient funds in account for transaction")
    end
  end

  def transactions
    @transactions = outgoing_transactions + incoming_transactions
    @transactions.sort_by { |t| t.created_at }
  end

  def last_transaction
    @transactions.last if @transactions
  end

  def withdraw(amt, force=false)
    self.force = force

    old_balance = self.balance
    self.balance -= amt
    self.save!

    self.force = false
  end

  def deposit(amt)
    self.balance += amt
    self.save!
  end
end
