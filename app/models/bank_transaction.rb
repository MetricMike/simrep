class BankTransaction < ActiveRecord::Base
  belongs_to :from_account, class_name: 'BankAccount', inverse_of: :bank_transactions
  belongs_to :to_account, class_name: 'BankAccount', inverse_of: bank_transactions

  after_create :move
  after_destroy :unmove

  def move
    self.transaction do
      from_account.withdraw(self.amount)
      to_account.deposit(self.amount)
    end
  end

  def unmove
    self.transaction do
      to_account.withdraw(self.amount)
      from_account.deposit(self.amount)
    end
  end
end