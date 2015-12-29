ActiveAdmin.register NpcShift do
  menu false

  index do
    selectable_column
    column :id do |ns|
      link_to ns.id, admin_npc_shift_path(ns)
    end
    column "Character", :character_event_id do |ns|
      link_to ns.character.name, admin_character_path(ns.character)
    end
    column :opening
    column :closing
    column :dirty
    column :updated_at
    actions
  end

  begin
    filter :character_event
    filter :opening
    filter :closing
    filter :dirty
  rescue
    p "msg"
  end

  form do |f|
    f.inputs do
      input :character_event, as: :select, collection: CharacterEvent.order_for_select
      input :opening, as: :date_time_picker, datepicker_options: { step: 15 }
      input :closing, as: :date_time_picker, datepicker_options: { step: 15 }
      input :dirty
    end

    f.actions
  end

  member_action :history do
    @npc_shift = NpcShift.find(params[:id])
    @versions = @npc_shift.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_npc_shift_path(resource)
  end

  controller do
    def show
      @npc_shift = NpcShift.includes(versions: :item).find(params[:id])
      @versions = @npc_shift.versions
      @npc_shift = @npc_shift.versions[params[:version].to_i].reify if params[:version]
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