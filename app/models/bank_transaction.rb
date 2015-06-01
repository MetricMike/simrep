class BankTransaction < ActiveRecord::Base
  REVERSAL_SUCCEED_NOTICE = "\n TRANSACTION REVERSED"
  REVERSAL_FAILED_NOTICE = "\n TRANSACTION REVERSAL FAILED"
  NSF_NOTICE = "\n INSUFFICENT FUNDS, NO EXCHANGE MADE"

  belongs_to :from_account, class_name: 'BankAccount'
  belongs_to :to_account, class_name: 'BankAccount'

  monetize :funds_cents, with_model_currency: :funds_currency, numericality: { greater_than_or_equal_to: 0 }

  after_create :post_transaction, unless: Proc.new { |bt| bt.posted == true }
  before_destroy :reverse_transaction, unless: Proc.new { |bt| bt.posted == false }

  def post_transaction
    begin
      self.transaction do
        from_account.withdraw(self.funds) if self.from_account
        to_account.deposit(self.funds) if self.to_account
        self.posted = true
      end
    rescue ActiveRecord::RecordInvalid => invalid
      self.memo = "#{self.memo.to_s + NSF_NOTICE}"
      self.save(validate: false)
    end
  end

  def reverse_transaction
    begin
      self.transaction do
        from_account.withdraw(self.funds) if self.from_account
        to_account.deposit(self.funds) if self.to_account
        self.memo = "#{self.memo.to_s + REVERSAL_SUCCEED_NOTICE}"
        self.posted = false
      end
    rescue ActiveRecord::RecordInvalid => invalid
      self.memo = "#{self.memo.to_s + REVERSAL_FAILED_NOTICE + NSF_NOTICE}"
      self.save(validate: false)
    end
  end
end