ActiveAdmin.register User do
  config.paginate = false

  index do
    selectable_column
    column :id do |u|
      link_to u.id, admin_user_path(u)
    end
    column :name
    column :email
    column "Password" do |u|
      status_tag (u.encrypted_password.present? ? :yes : :no)
    end
    column "Referral Used" do |u|
      status_tag (u.upstream_referral.try(:event_claimed) ? :yes : :no)
    end
    column :admin
    actions
  end

  filter :name
  filter :email
  filter :admin
  filter :encrypted_password_present, as: :boolean, label: 'Password?'
  filter :updated_at

  member_action :reset do
    resource.update(password: "password", password_confirmation: "password", confirmed_at: Time.now.utc)
    redirect_to resource_path, notice: "Reset with password == 'password'"
  end

  action_item :reset, only: :show do
    link_to "Reset", reset_admin_user_path(resource)
  end

  form do |f|
    f.inputs 'User' do
      f.input :name
      f.input :email
      f.input :admin
      f.input :options_skip_confirm, as: :boolean
      f.input :options_confirm, as: :boolean
    end
    f.actions
  end

  sidebar "Characters", only: [:show, :edit] do
    resource.characters.each { |c| div link_to c.name, admin_character_path(c) }
  end

  sidebar "Sponsored By", only: :show, if: proc{ resource.upstream_referral } do
    div link_to resource.sponsor.name, admin_character_path(resource.sponsor)
  end
  sidebar "Sponsoring", only: :show, if: proc{ !resource.downstream_referrals.empty? } do
    resource.referred_users.each do |ref|
      div link_to ref.name, admin_character_path(ref)
    end
  end

  # sidebar "Referrals", only: :index do
  #   active_admin_form_for :
  # end

  # f.inputs 'Referrals' do
    #   f.has_many :downstream_referrals, heading: "Referrals", allow_destroy: true do |dr|
    #     dr.input :sponsor_id, as: :hidden, input_html: { value: f.object.id }
    #     dr.input :referred_user_id, as: :select, collection: User.unsponsored.map { |u| [ u.name, u.id ] }
    #     dr.input :event_claimed_id, as: :select, collection: f.object.played_events.map { |e| [ "#{e.weekend} / #{e.campaign}", e.id ] }
    #   end
    #   f.has_many :upstream_referral, heading: "Sponsor", allow_destroy: true do |ur|
    #     ur.input :sponsor_id, as: :select, collection: User.all.map { |u| [ u.name, u.id ] }
    #     ur.input :referred_user_id, as: :select, input_html: { readonly: true, value: ur.object }
    #     ur.input :event_claimed_id, as: :select, collection: f.object.played_events.map { |e| [ "#{e.weekend} / #{e.campaign}", e.id ] }
    #   end
    # end

  # sidebar "Post a Transaction", priority: 0, only: :show do
  #   active_admin_form_for(:bank_transaction, url: admin_bank_transactions_path) do |f|
  #     f.inputs do
  #       f.input :from_account, collection: BankAccount.all, member_label: lambda { |a| a.owner.name }
  #       f.input :to_account, collection: BankAccount.all, member_label: lambda { |a| a.owner.name }
  #       f.input :funds, as: :number, default: 0.00
  #       f.input :funds_currency, as: :select, include_blank: false, collection: [Money::Currency.find(:vmk), Money::Currency.find(:sgd)], label_method: :name, value_method: :to_s
  #       f.input :memo, required: false
  #     end
  #     f.action :submit, label: "Post New Transaction"
  #   end
  # end

  controller do
    def create
      @user = User.new(params[:user])
      @user.skip_confirmation_notification! if params[:user][:skip_confirmation]
      @user.confirm! if params[:user][:skip_confirmation]

      if @user.save
        flash[:notice] = "User created."
      else
        flash[:notice] = "User creation failed with: #{@user.errors}"
      end

      redirect_to admin_user_path(@user)
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
