class IndexForeignKeysInBankTransactions < ActiveRecord::Migration
  def change
    add_index :bank_transactions, :from_account_id
    add_index :bank_transactions, :to_account_id
  end
end
