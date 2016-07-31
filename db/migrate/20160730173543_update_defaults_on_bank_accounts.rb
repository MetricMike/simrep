class UpdateDefaultsOnBankAccounts < ActiveRecord::Migration[5.0]
  def up
    change_column_default(:bank_accounts, :balance_cents, 0)
  end

  def down
    change_column_default(:bank_accounts, :balance_cents, 500)
  end
end
