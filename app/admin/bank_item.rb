ActiveAdmin.register BankItem do
  menu false
  belongs_to :bank_account, optional: true

  csv_importable :columns => [:from_account_id, :to_account_id, :item_description, :item_count]

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

  member_action :history do
    @bank_item = BankItem.find(params[:id])
    @versions = @bank_item.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_bank_item_path(resource)
  end

  controller do
    def show
      @bank_item = BankItem.includes(versions: :item).find(params[:id])
      @versions = @bank_item.versions
      @bank_item = @bank_item.versions[params[:version].to_i].reify if params[:version]
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
