class GroupBankAccount < BankAccount
  has_many :members, through: :group, class_name: 'Character'

  def display_name
    "(Joint) #{group.display_name} | #{self.chapter.name}"
  end
end
