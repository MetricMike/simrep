class PersonalBankAccount < BankAccount
  belongs_to :owner, class_name: 'Character'
  validates_presence_of :owner

  def owner_name
    "#{self.owner.display_name}"
  end

  def display_name
    "#{self.owner.display_name} | #{self.chapter.name}"
  end
end
