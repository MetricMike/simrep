class AddMissingForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :bank_accounts, :chapters
    add_foreign_key :characters, :chapters
    add_foreign_key :characters, :users
    add_foreign_key :deaths, :characters
    add_foreign_key :events, :chapters
    add_foreign_key :talents, :characters
  end
end
