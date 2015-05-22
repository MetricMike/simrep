class BankAccount < ActiveRecord::Base
  belongs_to :owner, class_name: 'Character'
  has_many :outgoing_transactions, class_name: 'BankTransaction', foreign_key: :from_account_id
  has_many :incoming_transactions, class_name: 'BankTransaction', foreign_key: :to_account_id
  monetize :balance_cents, :line_of_credit_cents
  
  def transactions
    outgoing_transactions + incoming_transactions
  end
  
  def last_transaction
    transactions.order(created_at: :desc).limit(1).first.try(:created_at)
  end


  def withdraw(amt)
    old_balance = self.balance
    self.balance -= amt
    if self.balance >= Money.new(0, 'VMK') - self.line_of_credit
      self.save
    else
      self.balance = old_balance
      return false
    end
  end
  
  def deposit(amt)
    self.balance += amt
    self.save
  end
end
