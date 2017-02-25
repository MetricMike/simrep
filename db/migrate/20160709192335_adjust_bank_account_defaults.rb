class AdjustBankAccountDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:bank_accounts,     :balance_currency,        nil)
    change_column_default(:bank_accounts,     :line_of_credit_currency, nil)
    change_column_default(:bank_transactions, :funds_currency,          nil)

    reversible do |dir|
      dir.up do
        BankAccount.where(chapter: Chapter.find_by(name: "Bastion")).map do |ba|
          ba.update(balance_currency: :vmk, line_of_credit_currency: :vmk)
        end

        holurheim_accounts = BankAccount.where(chapter: Chapter.find_by(name: "Holurheim"))

        holurheim_accounts.map do |ba|
          ba.update(balance_currency: :hkr, line_of_credit_currency: :hkr)
        end

        BankTransaction.where(from_account: holurheim_accounts)
        .or(BankTransaction.where(to_account: holurheim_accounts)).map do |bt|
          bt.update_columns(funds_currency: :hkr)
        end
      end
    end
  end
end
