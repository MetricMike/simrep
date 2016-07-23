class CreateJointBankAccounts < ActiveRecord::Migration[5.0]
  def change
    change_table :bank_accounts do |t|
      t.references :group, index: true, foreign_key: true
    end
  end
end
