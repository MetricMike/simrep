ActiveAdmin.register User do
  menu false
  config.per_page = 100

  includes upstream_referral: :event_claimed

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
    column "Annual Cleaning Coupon" do |u|
      if u.free_cleaning_event
        link_to u.free_cleaning_event.display_name, admin_character_event_path(u.free_cleaning_event)
      else
        status_tag 'Unused', :no
      end
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
    div link_to resource.sponsor.name, admin_user_path(resource.sponsor)
  end
  sidebar "Sponsoring", only: :show, if: proc{ !resource.downstream_referrals.empty? } do
    resource.referred_users.each do |ref|
      div link_to ref.name, admin_user_path(ref)
    end
  end

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
end
