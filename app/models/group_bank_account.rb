class GroupBankAccount < BankAccount
  belongs_to :group, required: true
  delegate :name, to: :group

  def transactions
    outgoing_transactions.union(incoming_transactions)
      .includes(from_account: :group, to_account: :group)
      .latest
  end

  def items
    outgoing_items.union(incoming_items)
      .includes(from_account: :group, to_account: :group)
      .latest
  end

  def display_name
    "#{self.group.name} | #{self.chapter.name}"
  end
end
