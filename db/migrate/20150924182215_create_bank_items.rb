class CreateBankItems < ActiveRecord::Migration
  def change
    create_table :bank_items do |t|
      t.references :from_account, null: true
      t.references :to_account, null: true
      t.string :item_description, null: true
      t.integer :item_count, null: false, default: 1

      t.timestamps null: false
    end

     add_foreign_key :bank_items, :characters, column: :from_account_id
     add_foreign_key :bank_items, :characters, column: :to_account_id
  end
end
