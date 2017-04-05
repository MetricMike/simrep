ActiveAdmin.register BankTransaction do
  menu false
  belongs_to :bank_account, optional: true

  index do
    selectable_column
    column :id
    column :from_account do |bt|
      if bt.from_account.present?
        link_to bt.from_account.owner.name, admin_personal_bank_account_path(bt.from_account.id)
      else
        "Deposit"
      end
    end
    column :to_account do |bt|
      if bt.to_account.present?
        link_to bt.to_account.owner.name, admin_personal_bank_account_path(bt.to_account.id)
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

      redirect_to :back and return
    end

    def bank_transaction_params
      params[:bank_transaction][:funds] = Money.new(params[:bank_transaction][:funds].to_f*100, params[:bank_transaction][:funds_currency])
      params[:bank_transaction][:from_account] = BankAccount.find_by id: params[:bank_transaction][:from_account] if params[:bank_transaction][:from_account]
      params[:bank_transaction][:to_account] = BankAccount.find_by id: params[:bank_transaction][:to_account] if params[:bank_transaction][:to_account]
      params.require(:bank_transaction).permit! #aaahhhhhhhh
    end
  end

  member_action :history do
    @bank_transaction = BankItem.find(params[:id])
    @versions = @bank_transaction.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_bank_item_path(resource)
  end

  controller do
    def show
      @bank_transaction = BankItem.includes(versions: :item).find(params[:id])
      @versions = @bank_transaction.versions
      @bank_transaction = @bank_transaction.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show

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
