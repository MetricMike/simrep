class AddTransactionForMoneyOnNpcShifts < ActiveRecord::Migration
  def change
    remove_monetize :npc_shifts, :real_pay

    add_reference :npc_shifts, :bank_transaction, index: true, foreign_key: true
  end
end
