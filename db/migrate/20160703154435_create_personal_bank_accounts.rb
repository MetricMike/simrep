class CreatePersonalBankAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :bank_accounts, :type, :string

    reversible do |dir|
      dir.up { BankAccount.all.map { |ba| ba.update(type: "PersonalBankAccount") } }
    end
  end
end
