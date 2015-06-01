ActiveAdmin.register BankAccount do

  show do
    panel "Details" do
        attributes_table do
          row :id
          row :owner
          row(:balance) { humanized_money_with_symbol bank_account.balance }
          row(:line_of_credit) { humanized_money_with_symbol bank_account.line_of_credit }
        end
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
  end

  sidebar "Post a Transaction", priority: 0, only: :show do
    "Post a transaction2"
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
