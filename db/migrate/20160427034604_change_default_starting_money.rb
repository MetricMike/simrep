class ChangeDefaultStartingMoney < ActiveRecord::Migration
  def change
    change_column_default :bank_accounts, :balance_cents, 500
  end
end
