ActiveAdmin.register BankTransaction do
  belongs_to :bank_account, optional: true

  csv_importable :columns => [:from_account_id, :to_account_id, :funds_cents, :funds_currency, :memo]

  filter :from_account
  filter :to_account
  filter :funds_cents
  filter :funds_currency
  filter :updated_at
  filter :posted

  controller do
    def create
      @bank_transaction = BankTransaction.new(bank_transaction_params)

      if @bank_transaction.save
        flash[:notice] = "Transaction posted."
      else
        flash[:notice] = "Transaction failed with: #{@bank_transaction.errors.messages}"
      end

      redirect_to :back and return
    end

    def bank_transaction_params
      params[:bank_transaction][:funds] = Money.new(params[:bank_transaction][:funds].to_f*100, params[:bank_transaction][:funds_currency])
      params[:bank_transaction][:from_account] = BankAccount.find_by id: params[:bank_transaction][:from_account] if params[:bank_transaction][:from_account]
      params[:bank_transaction][:to_account] = BankAccount.find_by id: params[:bank_transaction][:to_account] if params[:bank_transaction][:to_account]
      params.require(:bank_transaction).permit! #aaahhhhhhhh
    end
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end



end
