class ChangeForeignKeyOnBankItems < ActiveRecord::Migration
  def change
    remove_foreign_key :bank_items, column: :from_account_id
    remove_foreign_key :bank_items, column: :to_account_id

    add_foreign_key :bank_items, :bank_accounts, column: :from_account_id
    add_foreign_key :bank_items, :bank_accounts, column: :to_account_id
  end
end
