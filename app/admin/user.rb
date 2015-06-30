ActiveAdmin.register User do

  index do
    selectable_column
    column :id
    column :name
    column :email
    column :confirmed_at
    column :confirmation_sent_at
    column :sign_in_count
    column :last_sign_in_at
    column :admin
  end

  filter :name
  filter :admin
  filter :confirmed_at
  filter :last_sign_in_at
  filter :created_at

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

  controller do
    def create
      @user = User.new(user_params)
      @user.skip_confirmation_notification! if params[:user][:skip_confirmation]
      @user.confirm! if params[:user][:skip_confirmation]

      if @user.save
        flash[:notice] = "User created."
      else
        flash[:notice] = "User creation failed with: #{@user.errors.message}"
      end
    end

    def user_parms
      params.require(:email).permit(:name, :admin, :confirm, :skip_confirmation)
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
