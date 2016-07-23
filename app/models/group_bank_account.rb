class GroupBankAccount < BankAccount
  belongs_to :group, required: true

  def owner_name
    "#{self.group_display_name}"
  end

  def display_name
    "#{self.group.display_name} | #{self.chapter.name}"
  end
end
