ActiveAdmin.register BankTransaction do
  menu false
  belongs_to :bank_account, optional: true

  index do
    selectable_column
    column :id
    column :from_account do |bt|
      if bt.from_account.present?
        link_to bt.from_account.display_name, admin_bank_account_path(bt.from_account.id)
      else
        "Deposit"
      end
    end
    column :to_account do |bt|
      if bt.to_account.present?
        link_to bt.to_account.display_name, admin_bank_account_path(bt.to_account.id)
      else
        "Withdrawal"
      end
    end
    column :memo
    column :funds_cents
    column :funds_currency
    column :posted
    column :created_at
    column :updated_at
    actions
  end

  filter :from_account
  filter :to_account
  filter :funds_cents
  filter :funds_currency
  filter :updated_at
  filter :posted
  filter :memo

  controller do
    def create
      @bank_transaction = BankTransaction.new(bank_transaction_params)

      if @bank_transaction.save
        flash[:notice] = "Transaction posted."
      else
        flash[:notice] = "Transaction failed with: #{@bank_transaction.errors.messages}"
      end

      redirect_back(fallback_location: admin_bank_accounts_path)
    end

    def bank_transaction_params
      params[:bank_transaction][:funds] = Money.new(params[:bank_transaction][:funds].to_f*100, params[:bank_transaction][:funds_currency])
      params[:bank_transaction][:from_account] = BankAccount.find_by id: params[:bank_transaction][:from_account] if params[:bank_transaction][:from_account]
      params[:bank_transaction][:to_account] = BankAccount.find_by id: params[:bank_transaction][:to_account] if params[:bank_transaction][:to_account]
      params.require(:bank_transaction).permit! #aaahhhhhhhh
    end
  end
end
