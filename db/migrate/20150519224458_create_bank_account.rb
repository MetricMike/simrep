class CreateBankAccount < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :owner, index: true
      t.monetize :balance, amount: { default: 1000 }
      t.monetize :line_of_credit, amount: { default: 500 }
      
      t.timestamps null: false
    end

    add_foreign_key :bank_accounts, :characters, column: :owner_id
  end
end
