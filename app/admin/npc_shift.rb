ActiveAdmin.register NpcShift do
  menu false

  index do
    selectable_column
    column :id do |ns|
      link_to ns.id, admin_npc_shift_path(ns)
    end
    column "Character", :character_event_id do |ns|
      link_to ns.character_event.character.name, admin_character_path(ns.character_event.character)
    end
    column :opening
    column :closing
    column :hours_to_money
    column :hours_to_time
    column :verified
    column :dirty
    column :money_paid
    column :time_paid
    column :updated_at
    actions
  end

  begin
    filter :character_event
    filter :opening
    filter :closing
    filter :verified
    filter :dirty
  rescue
    p "msg"
  end

  form do |f|
    f.inputs do
      input :character_event, as: :select, collection: CharacterEvent.includes(:character, :event).all.order('events.weekend DESC, characters.name').references(:events, :characters)
      input :opening, as: :date_time_picker, datepicker_options: { step: 15 }
      input :closing, as: :date_time_picker, datepicker_options: { step: 15 }
      input :verified
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