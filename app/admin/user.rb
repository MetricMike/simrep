ActiveAdmin.register User do
  config.paginate = false

  index do
    selectable_column
    column :id do |u|
      link_to u.id, admin_user_path(u)
    end
    column :name
    column :email
    column :confirmed_at
    column :confirmation_sent_at
    column :sign_in_count
    column :last_sign_in_at
    column :admin
    actions
  end

  filter :name
  filter :email
  filter :admin
  filter :encrypted_password_present, as: :boolean, label: 'Password?'
  filter :reset_password_sent_at
  filter :confirmed_at
  filter :last_sign_in_at
  filter :created_at

  member_action :reset do
    resource.update(password: "password", password_confirmation: "password", confirmed_at: Time.now.utc)
    redirect_to resource_path, notice: "Reset with password == 'password'"
  end

  action_item :reset, only: :show do
    link_to "Reset", reset_admin_user_path(resource)
  end

  form do |f|
    f.inputs do
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
