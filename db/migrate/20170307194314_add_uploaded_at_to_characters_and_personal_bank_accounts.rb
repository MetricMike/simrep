class AddUploadedAtToCharactersAndPersonalBankAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :uploaded_at, :datetime
    add_column :bank_accounts, :uploaded_at, :datetime
  end
end
