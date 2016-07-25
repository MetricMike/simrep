class GroupBankAccount < BankAccount
  belongs_to :group, required: true

  delegate :name, to: :group

  def display_name
    "#{self.group.name} | #{self.chapter.name}"
  end
end
