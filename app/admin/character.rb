ActiveAdmin.register Character do

  batch_action :attend_event, form: {
    event:    Event.order(weekend: :desc).pluck(:weekend, :id),
    paid:     :checkbox,
    cleaned:  :checkbox,
  } do |ids, inputs|
    batch_action_collection.find(ids).each do |character|
      character.attend_event(inputs[:event], inputs[:paid], inputs[:cleaned])
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  batch_action :kill, form: {
    description:  :text,
    physical:     :text,
    roleplay:     :text,
    date:         Event.order(weekend: :desc).pluck(:weekend),
  } do |ids, inputs|
    batch_action_collection.find(ids).each do |character|
      character.deaths.create(inputs)
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  action_item :view, only: [:show, :edit] do
    link_to 'View on Site', character_path(character)
  end

  index do
    selectable_column
    column :id
    column :name
    column :race
    column :culture
    column :costume
    column :history_approval
    column :unused_talents
    column :perm_chance
    column :perm_counter
    actions
  end

  filter :name
  filter :race
  filter :culture
  filter :skills
  filter :perks
  filter :talents
  filter :events
  filter :backgrounds
  filter :origins
  filter :projects
  filter :deaths
  filter :perm_chance

  form do |f|
    tabs do

      tab 'Demographics' do
        f.inputs 'Demographics' do
          f.input :user
          f.input :name
          f.input :costume #input_html: { value: 0 } this is overriding default value
          f.input :history_approval
          f.input :history_link
          f.input :race, collection: Character::RACES
          f.input :culture, collection: Character::CULTURES
          f.input :unused_talents
        end

        f.inputs 'Character Origins' do
          f.has_many :origins, allow_destroy: true do |co_f|
            co_f.input :source, collection: (Character::RACES|Character::CULTURES)
            co_f.input :name
            co_f.input :detail
          end
        end

        f.inputs 'Character Backgrounds' do
          f.has_many :backgrounds, allow_destroy: true do |cb_f|
            cb_f.input :name
            cb_f.input :detail
          end
        end

      end

      tab 'Events & Custom XP' do

        f.inputs 'Events', header: "" do
          f.has_many :character_events, allow_destroy: true do |ce_f|
            ce_f.input :event, collection: Event.pluck(:weekend, :campaign, :id).map! { |a| [ "#{a[0]} / #{a[1]}", a[2] ] }
            ce_f.input :paid, label: "Paid?"
            ce_f.input :cleaned, label: "Cleaned?"
          end
        end

        panel "Custom XP" do
          para "Due to the way XP is associated with events, Legacy/Staff/Custom XP can only be assigned by making a fake event."
          para "This is not ideal, and must be done via console so that Michael fixes the XP/Event system."
        end

      end

      tab 'Mechanics' do

        f.inputs 'Skills', header: "" do
          f.has_many :skills, allow_destroy: true do |s_f|
            s_f.input :source, collection: Skill::SOURCES
            s_f.input :name
            s_f.input :cost
          end
        end

        f.inputs 'Perks', header: "" do
          f.has_many :perks, allow_destroy: true do |p_f|
            p_f.input :source, collection: Perk::SOURCES
            p_f.input :name
            p_f.input :cost
          end
        end

        f.inputs 'Talents', header: "" do
          f.has_many :talents, allow_destroy: true do |t_f|
            t_f.input :spec
            t_f.input :group, collection: Talent::GROUPS
            t_f.input :name
            t_f.input :value
            t_f.input :investment_limit
          end
        end

      end

      tab 'Deaths & Projects' do
        para "This panel requires a character to be refreshed before you
              can select an event to 'die' at or a talent to contribute with."

        f.inputs 'Deaths', header: "" do
          f.has_many :deaths, allow_destroy: true do |d_f|
            d_f.input :date, as: :select, collection: f.object.character_events.to_a.map { |ce| [ "#{Event.find(ce.event_id).weekend} / #{Event.find(ce.event_id).campaign}", Event.find(ce.event_id).weekend ] }
            #d_f.input :date, as: :select, collection: f.object.character_events.to_a, member_label: Proc.new { |ce| "#{Event.find(ce.event_id).weekend} / #{Event.find(ce.event_id).campaign}" }, member_value: Proc.new { |ce| Event.find(ce.event_id).weekend }
            d_f.input :description
            d_f.input :physical
            d_f.input :roleplay
          end
        end


        f.inputs 'Project Contributions', header: "" do
          f.has_many :project_contributions, allow_destroy: true do |pc_f|
            pc_f.input :project
            pc_f.input :timeunits
            pc_f.input :talent, collection: f.object.talents.map { |t| [ "#{t.rank} - #{t.name}", t.id ] }
            pc_f.input :note
          end
        end

      end

    end
    f.actions do
      action :submit, label: "Refresh"
      action :submit
      cancel_link
    end
  end

  controller do
    def new
      resource = Character.new(params[:character]) if params[:character]
      new!
    end

    def create
      if params[:commit] == 'Refresh'
        redirect_to new_admin_character_path(request.parameters)
      else
        create!
      end
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
