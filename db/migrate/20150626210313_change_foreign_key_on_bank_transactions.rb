class ChangeForeignKeyOnBankTransactions < ActiveRecord::Migration
  def change
    remove_foreign_key :bank_transactions, column: :from_account_id
    remove_foreign_key :bank_transactions, column: :to_account_id

    add_foreign_key :bank_transactions, :bank_accounts, column: :from_account_id
    add_foreign_key :bank_transactions, :bank_accounts, column: :to_account_id
  end
end
