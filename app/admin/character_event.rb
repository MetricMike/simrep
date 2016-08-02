ActiveAdmin.register CharacterEvent do
  menu false
  config.paginate = false

  index do
    selectable_column
    column :id do |ce|
      link_to ce.id, admin_character_event_path(ce)
    end
    column "Character", :character_id, sortable: 'characters.name' do |ce|
      link_to ce.character.name, admin_character_path(ce.character)
    end
    column "Event", :event_id, sortable: 'events.weekend' do |ce|
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
  rescue
    p "msg"
  end

  batch_action :mark_attendance, form: {
    paid:                :checkbox,
    cleaned:             :checkbox,
    check_clean_coupon:  :checkbox,
    override:            :checkbox
  } do |ids, inputs|
    batch_action_collection.find(ids).each do |ce|
      ce.character.attend_event(ce.event_id, inputs[:paid], inputs[:cleaned], inputs[:check_clean_coupon], inputs[:override])
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  batch_action :mass_pay, form: {
    funds_cents:    :text,
    funds_currency: [:vmk, :sgd, :hkr],
    memo:           :text
  } do |ids, inputs|
    batch_action_collection.find(ids).each do |ce|
      ce.character.primary_bank_account
        .incoming_transactions.create(funds_cents: inputs[:funds_cents],
                                      funds_currency: inputs[:funds_currency],
                                      memo: inputs[:memo])
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  batch_action :clear_clean_coupon do |ids, inputs|
    batch_action_collection.find(ids).each do |ce|
      ce.character.user.update(free_cleaning_event_id: nil)
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  batch_action :mass_kill, form: {
    description:  :text,
    physical:     :text,
    roleplay:     :text,
  } do |ids, inputs|
    batch_action_collection.find(ids).each do |ce|
      inputs[:weekend] = ce.event.weekend
      ce.character.deaths.create(inputs)
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  controller do
    def scoped_collection
      super.includes :character, :event
    end

    def show
      @character_event = CharacterEvent.includes(versions: :item).find(params[:id])
      @versions = @character_event.versions
      @character_event = @character_event.versions[params[:version].to_i].reify if params[:version]
      show!
    end

  end

  member_action :history do
    @character_event = CharacterEvent.find(params[:id])
    @versions = @character_event.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_character_event_path(resource)
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
