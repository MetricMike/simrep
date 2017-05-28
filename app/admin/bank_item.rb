ActiveAdmin.register BankItem do
  menu false
  belongs_to :bank_account, optional: true

  index do
    selectable_column
    column :id
    column :from_account do |bi|
      if bi.from_account.present?
        link_to bi.from_account.name, admin_bank_account_path(bi.from_account.id)
      else
        "Deposit"
      end
    end
    column :to_account do |bi|
      if bi.to_account.present?
        link_to bi.to_account.name, admin_bank_account_path(bi.to_account.id)
      else
        "Withdrawal"
      end
    end
    column :item_description
    column :item_count
    column :created_at
    column :updated_at
    actions
  end

  filter :from_account
  filter :to_account
  filter :item_description
  filter :item_count
  filter :updated_at

  controller do
    def create
      @bank_item = BankItem.new(bank_item_params)

      if @bank_item.save
        flash[:notice] = "Item added."
      else
        flash[:notice] = "Item add failed with: #{@bank_item.errors.messages}"
      end

      redirect_to :back and return
    end

    def bank_item_params
      if params[:bank_item]
        params[:bank_item][:from_account] = BankAccount.find_by id: params[:bank_item][:from_account] if params[:bank_item][:from_account]
        params[:bank_item][:to_account] = BankAccount.find_by id: params[:bank_item][:to_account] if params[:bank_item][:to_account]
      end
      params.require(:bank_item).permit! #aaahhhhhhhh
    end
  end

end
