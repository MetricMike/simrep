class IndexForeignKeysInBankItems < ActiveRecord::Migration
  def change
    add_index :bank_items, :from_account_id
    add_index :bank_items, :to_account_id
  end
end
