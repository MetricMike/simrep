class BankItem < ActiveRecord::Base
  scope :latest, -> { order(updated_at: :desc) }

  belongs_to :from_account, class_name: 'BankAccount'
  belongs_to :to_account, class_name: 'BankAccount'

  def display_name
    "#{self.item_description} (x#{self.item_count})"
  end
end