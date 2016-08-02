ActiveAdmin.register BankAccount do
  menu false

  action_item :view, only: [:show, :edit] do
    if resource.type == 'PersonalBankAccount'
      link_to 'View on Site', bank_account_path
    end
  end

  index do
    selectable_column
    column :id do |ba|
      link_to ba.id, polymorphic_path([:admin, ba])
    end
    column :type
    column :name do |ba|
      ba.name
    end
    column :chapter
    column :balance_cents
    column :balance_currency
    column :created_at
    column :updated_at
    actions
  end

  filter :type
  filter :name
  filter :balance_cents
  filter :balance_currency
  filter :chapter_name

  show do
    attributes_table do
      row :id
      row(:balance) { humanized_money_with_symbol bank_account.balance }
      row(:line_of_credit) { humanized_money_with_symbol bank_account.line_of_credit }
    end
    panel "Transactions" do
      tabs do
        tab "Incoming" do
          table_for bank_account.incoming_transactions.order(params[:order].to_s.gsub(/(.*)(_)(.*)/, '\1 \3')), sortable: true do
            column :id
            column(:source, sortable: :from_account_id) { |t| t.from_account ? t.from_account.owner.name : "Cash Deposit" }
            column :memo, sortable: false
            column(:funds, sortable: :funds_cents) { |t| humanized_money_with_symbol t.funds }
            column(:date, sortable: :updated_at) { |t| t.updated_at }
            column :posted, sortable: :posted
          end
        end
        tab "Outgoing" do
          table_for bank_account.outgoing_transactions.order(params[:order].to_s.gsub(/(.*)(_)(.*)/, '\1 \3')), sortable: true do
            column :id
            column(:destination, sortable: :to_account_id) { |t| t.to_account ? t.to_account.owner.name : "Cash Withdrawal" }
            column :memo, sortable: false
            column(:funds, sortable: :funds_cents) { |t| humanized_money_with_symbol t.funds }
            column(:date, sortable: :updated_at) { |t| t.updated_at }
            column :posted, sortable: :posted
          end
        end
      end
    end
    panel "Items" do
      tabs do
        tab "Incoming" do
          table_for bank_account.incoming_items.order(params[:order].to_s.gsub(/(.*)(_)(.*)/, '\1 \3')), sortable: true do
            column :id
            column(:source, sortable: :from_account_id) { |t| t.from_account ? t.from_account.owner.name : "Deposit" }
            column :item_description, sortable: false
            column :item_count, sortable: false
            column(:date, sortable: :updated_at) { |t| t.updated_at }
          end
        end
        tab "Outgoing" do
          table_for bank_account.outgoing_items.order(params[:order].to_s.gsub(/(.*)(_)(.*)/, '\1 \3')), sortable: true do
            column :id
            column(:destination, sortable: :to_account_id) { |t| t.to_account ? t.to_account.owner.name : "Withdrawal" }
            column :item_description, sortable: false
            column :item_count, sortable: false
            column(:date, sortable: :updated_at) { |t| t.updated_at }
          end
        end
      end
    end
  end

  sidebar "Post a Transaction", priority: 0, only: :show do
    active_admin_form_for(:bank_transaction, url: admin_bank_transactions_path) do |f|
      f.inputs do
        f.input :from_account, collection: BankAccount.all
        f.input :to_account, collection: BankAccount.all
        f.input :funds, as: :number, default: 0.00
        f.input :funds_currency, as: :select, include_blank: false, collection: [Money::Currency.find(:vmk), Money::Currency.find(:sgd), Money::Currency.find(:hkr)], label_method: :name, value_method: :to_s
        f.input :memo, required: false
      end
      f.action :submit, label: "Post New Transaction"
    end
  end

  sidebar "Add an Item", priority: 1, only: :show do
    active_admin_form_for(:bank_item, url: admin_bank_items_path) do |f|
      f.inputs do
        f.input :from_account, collection: BankAccount.all
        f.input :to_account, collection: BankAccount.all
        f.input :item_description, required: false
        f.input :item_count, as: :number, default: 1
      end
      f.action :submit, label: "Add Item"
    end
  end

  member_action :history do
    @bank_account = BankAccount.find(params[:id])
    @versions = @bank_account.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_bank_account_path(resource)
  end

  controller do
    def show
      @bank_account = BankAccount.includes(versions: :item).find(params[:id])
      @versions = @bank_account.versions
      @bank_account = @bank_account.versions[params[:version].to_i].reify if params[:version]
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
