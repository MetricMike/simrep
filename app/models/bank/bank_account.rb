class BankAccount < ActiveRecord::Base
  belongs_to :owner, class_name: 'Character', inverse_of: :bank_accounts
  has_many :bank_transactions, inverse_of: :bank_accounts
  monetize :balance_cents, :line_of_credit_cents
  
  #doesnt save, probably going to be an issue
  attr_accessible :line_of_credit

  def withdraw(amt)
    old_balance = balance
    balance -= amt
    if balance >= Money.new(0, 'VMK') - line_of_credit
      self.save
    else
      balance = old_balance
      return false
    end
  end
  
  def deposit(amt)
    balance += amt
    self.save
  end
end
