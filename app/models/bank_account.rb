class BankAccount < ActiveRecord::Base
  belongs_to :owner, class_name: 'Character'
  has_many :bank_transactions
  monetize :balance_cents, :line_of_credit_cents

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
