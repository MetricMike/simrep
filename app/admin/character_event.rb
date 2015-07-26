ActiveAdmin.register CharacterEvent do
  config.paginate = false

  index do
    selectable_column
    column :id do |ce|
      link_to ce.id, admin_character_event_path(ce)
    end
    column "Character", :character_id, sortable: :name do |ce|
      link_to ce.character.name, admin_character_path(ce.character)
    end
    column "Event", :event_id, sortable: :weekend do |ce|
      link_to ce.event.display_name, admin_event_path(ce.event)
    end
    column :paid
    column :cleaned
    column :accumulated_npc_timeunits
    column :accumulated_npc_money, sortable: :accumulated_npc_money_cents do |ce|
      humanized_money_with_symbol ce.accumulated_npc_money
    end
    column :awarded
    column :updated_at
    actions
  end

  begin
    filter :character_name, as: :string
    filter :event_weekend, as: :date_range
    filter :paid, as: :check_boxes
    filter :cleaned, as: :check_boxes
    filter :awarded, as: :check_boxes
    filter :accumulated_npc_money_cents
    filter :accumulated_npc_timeunits
  rescue
    p "msg"
  end

  batch_action :mark_attendance, form: {
    paid:     :checkbox,
    cleaned:  :checkbox,
    override:  :checkbox
  } do |ids, inputs|
    batch_action_collection.find(ids).each do |ce|
      ce.character.attend_event(ce.event_id, inputs[:paid], inputs[:cleaned], inputs[:override])
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  controller do
    def scoped_collection
      super.includes :character, :event
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
