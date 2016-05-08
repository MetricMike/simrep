class BankTransaction < ApplicationRecord
  REVERSAL_SUCCEED_NOTICE = "\n TRANSACTION REVERSED"
  REVERSAL_FAILED_NOTICE = "\n TRANSACTION REVERSAL FAILED"
  NSF_NOTICE = "\n INSUFFICENT FUNDS, NO EXCHANGE MADE"

  scope :latest, -> { order(updated_at: :desc) }

  belongs_to :from_account, class_name: 'BankAccount'
  belongs_to :to_account, class_name: 'BankAccount'

  monetize :funds_cents, with_model_currency: :funds_currency, numericality: { greater_than_or_equal_to: 0 }

  before_save :post_transaction
  before_destroy :reverse_transaction

  def post_transaction
    outgoing = posted? ? to_account : from_account
    incoming = posted? ? from_account : to_account

    if ((outgoing.try(:withdraw, funds) == false) || (incoming.try(:deposit, funds) == false))
      self.memo = self.memo.to_s + (posted? ? REVERSAL_FAILED_NOTICE+NSF_NOTICE : NSF_NOTICE)
      errors[:base] << memo.to_s
      return false
    else
      self.memo = self.memo.to_s + (posted? ? REVERSAL_SUCCEED_NOTICE : "")
      self.posted = !posted?
      return true
    end
  end
  alias_method :reverse_transaction, :post_transaction

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