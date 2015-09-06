ActiveAdmin.register CraftingPoint do
  belongs_to :character, optional: true
  actions :all, except: [:show, :edit, :new]
  config.paginate = false

  # action_item :view, only: [:show, :edit] do
  #   link_to 'View on Site', bank_account_path(bank_account)
  # end

  index do
    selectable_column
    column :id do |cp|
      link_to cp.id, admin_crafting_point_path(cp)
    end
    column :character do |cp|
      link_to Character.find(cp.character_id).name, admin_character_path(cp.character_id)
    end
    column :type
    column :unranked
    column :apprentice
    column :journeyman
    column :master
    column :created_at
    column :updated_at
  end

  filter :character_name
  filter :type, as: :select, collection: CraftingPoint::TYPES
  filter :unranked
  filter :apprentice
  filter :journeyman
  filter :master
  filter :created_at
  filter :updated_at

  sidebar "Post a Transaction", priority: 0, only: :index do
    active_admin_form_for(:crafting_point, url: admin_crafting_points_path) do |f|
      f.inputs do
        f.input :character_id, collection: Character.all, member_label: lambda { |a| a.name }
        f.input :type, collection: CraftingPoint::TYPES
        f.input :unranked, input_html: { value: 0 }
        f.input :apprentice, input_html: { value: 0 }
        f.input :journeyman, input_html: { value: 0 }
        f.input :master, input_html: { value: 0 }
      end
      f.action :submit, label: "Post Change"
    end
  end

  controller do
    def create
      cp_record = Character.find(params[:crafting_point][:character_id]).crafting_points.where(type: params[:crafting_point][:type]).try(:first)
      if cp_record
        cp_record.update(params[:crafting_point])
      else
        CraftingPoint.create(params[:crafting_point])
      end

      redirect_to admin_crafting_points_path
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