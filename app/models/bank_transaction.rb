class BankTransaction < ActiveRecord::Base
  REVERSAL_SUCCEED_NOTICE = "\n TRANSACTION REVERSED"
  REVERSAL_FAILED_NOTICE = "\n TRANSACTION REVERSAL FAILED"
  NSF_NOTICE = "\n INSUFFICENT FUNDS, NO EXCHANGE MADE"

  scope :latest, -> { order(updated_at: :desc) }

  belongs_to :from_account, class_name: 'BankAccount'
  belongs_to :to_account, class_name: 'BankAccount'

  monetize :funds_cents, with_model_currency: :funds_currency, numericality: { greater_than_or_equal_to: 0 }

  after_save :post_transaction, unless: Proc.new { |bt| bt.posted == true }
  before_destroy :reverse_transaction, unless: Proc.new { |bt| bt.posted == false }

  def post_transaction
    begin
      self.transaction do
        from_account.withdraw(self.funds) if self.from_account
        to_account.deposit(self.funds) if self.to_account
        self.update!(posted: true)
      end
    rescue ActiveRecord::RecordInvalid => invalid
      self.memo = "#{self.memo.to_s + NSF_NOTICE}"
      #self.save(validate: false)
    end
  end

  def reverse_transaction
    begin
      self.transaction do
        from_account.deposit(self.funds) if self.from_account
        to_account.withdraw(self.funds) if self.to_account
        self.memo = "#{self.memo.to_s + REVERSAL_SUCCEED_NOTICE}"
        self.update!(posted: false)
      end
    rescue ActiveRecord::RecordInvalid => invalid
      self.memo = "#{self.memo.to_s + REVERSAL_FAILED_NOTICE + NSF_NOTICE}"
      #self.save(validate: false)
    end
  end

  def display_name
    if self.to_account.nil?
      "Cash Withdrawal of #{self.funds} from #{self.from_account.owner.display_name}"
    elsif self.from_account.nil?
      "Cash Deposit of #{self.funds} to #{self.to_account.owner.display_name}"
    else
      "Transfer of #{self.funds} from #{self.from_account.owner.display_name} to #{self.to_account.owner.display_name}"
    end
  end
end