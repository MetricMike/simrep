class BankTransaction < ActiveRecord::Base
  belongs_to :from_account, class_name: 'BankAccount'
  belongs_to :to_account, class_name: 'BankAccount'
  
  monetize :funds_cents, with_model_currency: :funds_currency, numericality: { greater_than_or_equal_to: 0 }

  after_create :move
  after_destroy :unmove

  def move
    self.transaction do
      from_account.withdraw(self.funds) if self.from_account
      to_account.deposit(self.funds) if self.to_account
    end
  end

  def unmove
    self.transaction do
      to_account.withdraw(self.funds) if self.to_account
      from_account.deposit(self.funds) if self.from_account
    end
  end
end