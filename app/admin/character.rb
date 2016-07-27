ActiveAdmin.register Character do
  menu false
  config.per_page = [25, 50, 100, 1000]

  includes :user, :bank_accounts

  scope("Recent Players") { |scope| scope.recently_played.newest }

  csv force_quotes: true do
    column("Player Name", humanize_name: false) { |c| c.user.display_name }
    column("Character Name", humanize_name: false) { |c| c.display_name }
    column("Current Chapter", humanize_name: false) { |c| c.chapter.name }
    column("Bank Account Balance", humanize_name: false) { |c| (c.primary_bank_account.try(:balance)) || "ERR" }
    column("Unspent Skills", humanize_name: false) { |c| c.skill_points_unspent }
    column("Unspent Perks", humanize_name: false) { |c| c.perk_points_unspent }
    column("Unspent TUs", humanize_name: false) { |c| c.unused_talents }
  end

  batch_action :attend_event, form: {
    event:               Event.newest.limit(20).map { |e| [e.display_name, e.id] },
    paid:                :checkbox,
    cleaned:             :checkbox,
    check_clean_coupon:  :checkbox,
    override:            :checkbox
    } do |ids, inputs|
      batch_action_collection.find(ids).each do |character|
        character.attend_event(inputs[:event], inputs[:paid], inputs[:cleaned], inputs[:check_clean_coupon], inputs[:override])
      end
      redirect_to collection_path, notice: [ids, inputs].to_s
  end

  batch_action :kill, form: {
    description:  :text,
    physical:     :text,
    roleplay:     :text,
    weekend:      Event.newest,
    } do |ids, inputs|
      batch_action_collection.find(ids).each do |character|
        character.deaths.create(inputs)
      end
      redirect_to collection_path, notice: [ids, inputs].to_s
  end

  action_item :view, only: [:show, :edit] do
    link_to 'View on Site', character_path(character)
  end

  member_action :history do
    @character = Character.find(params[:id])
    @versions = @character.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_character_path(resource)
  end

  index do
    selectable_column
    column :id do |c|
      link_to c.id, admin_character_path(c)
    end
    column :player_name do |c|
      if c.user.present?
        link_to c.user.name, admin_user_path(c.user)
      else
        "N/A"
      end
    end
    column :character_name do |c|
      c.name
    end
    column :chapter
    column :race
    column :culture
    column :costume
    column :history_approval
    column :unused_talents
    column "Bank Account", :bank_account do |c|
      link_to humanized_money_with_symbol(c.bank_accounts_personal_accounts.first.balance),
        admin_personal_bank_account_path(c.bank_accounts_personal_accounts.first)
    end
    actions
  end

  filter :name
  filter :race
  filter :chapter
  filter :culture
  filter :character_skills_skill_name, as: :string
  filter :perks
  filter :talents
  filter :events
  filter :backgrounds
  filter :origins

  form do |f|
    tabs do

      tab 'Demographics' do
        f.inputs 'Demographics' do
          f.input :user
          f.input :name
          f.input :chapter
          f.input :costume #input_html: { value: 0 } this is overriding default value
          f.input :history_approval
          f.input :history_link
          f.input :race, collection: Character::RACES
          f.input :culture, collection: Character::CULTURES
          f.input :unused_talents
        end

        f.inputs 'Character Origins' do
          f.has_many :origins, allow_destroy: true do |co_f|
            co_f.input :source, collection: (Character::RACES|Character::CULTURES), label: false
            co_f.input :name, label: false
            co_f.input :detail, label: false
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
            ce_f.input :event
            ce_f.input :paid, label: "Paid?"
            ce_f.input :cleaned, label: "Cleaned?"
          end
        end

        panel "Bonus/Custom XP" do
          f.has_many :bonus_experiences, allow_destroy: true do |be_f|
            be_f.input :reason
            be_f.input :amount
            be_f.input :date_awarded, as: :date_picker
          end
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
            d_f.input :weekend, as: :select, collection: f.object.events.pluck(:weekend)
            d_f.input :description
            d_f.input :physical
            d_f.input :roleplay
          end
        end


        f.inputs 'Project Contributions', header: "" do
          f.has_many :project_contributions, allow_destroy: true do |pc_f|
            pc_f.input :project, collection: Project.all.includes(:leader)
            pc_f.input :timeunits
            pc_f.input :talent, collection: f.object.talents
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

    def edit
      resource = Character.includes({character_events: :event}, :talents, :deaths, {project_contributions: :project})
                          .find(params[:id])
      edit!
    end

    def show
      @character = Character.includes(:bank_accounts).find(params[:id])
      @versions = @character.versions
      @character = @character.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show

  sidebar :personal_bank_account, only: :show do
    h3 "Chapter | Current Balance"
    ul do
      resource.bank_accounts_personal_accounts.each do |b|
        li a "#{b.chapter.name} | #{humanized_money_with_symbol b.balance}", href: admin_personal_bank_account_path(b)
      end
    end
  end

end
