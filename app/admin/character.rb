ActiveAdmin.register Character do

  batch_action :attend_event, form: {
      event:    Event.pluck(:weekend, :id).sort_by!(&:first).reverse,
      paid:     :checkbox,
      cleaned:  :checkbox,
    } do |ids, inputs|
    batch_action_collection.find(ids).each do |character|
      character.attend_event(inputs[:event], inputs[:paid], inputs[:cleaned])
    end
    redirect_to collection_path, notice: [ids, inputs].to_s
  end

  action_item :view, only: [:show, :edit] do
    link_to 'View on Site', character_path(character)
  end

  form do |f|
    tabs do

      tab 'Demographics' do
        f.inputs 'Demographics' do
          f.inputs :user, :name, :costume, :costume_checked, :history_approval, :history_link, :unused_talents
          f.input :race, collection: Character::RACES
          f.input :culture, collection: Character::CULTURES
        end

        f.inputs 'Character Origins' do
          f.semantic_fields_for :character_origins do |co_f|
            co_f.inputs 'Origin', header: "" do
              co_f.semantic_fields_for :origin, co_f.object.origin, allow_destroy: true do |o_f|
                o_f.input :source, collection: (Character::RACES|Character::CULTURES)
                o_f.input :name
                o_f.input :detail
              end
            end
          end
        end

        f.inputs 'Character Backgrounds' do
          f.semantic_fields_for :character_backgrounds do |cb_f|
            cb_f.inputs 'Background', header: "" do
              cb_f.semantic_fields_for :background, cb_f.object.background, allow_destroy: true do |b_f|
                b_f.input :name
                b_f.input :detail
              end
            end
          end
        end

      end

      tab 'Events & Deaths' do

        f.inputs 'Events', header: "" do
          f.semantic_fields_for :character_events, allow_destroy: true do |ce_f|
            ce_f.inputs 'Event', header: "" do
              ce_f.input :event, collection: Event.pluck(:weekend, :campaign, :id).map! { |a| [ "#{a[0]} / #{a[1]}", a[2] ] }
              ce_f.input :paid, label: "Paid XP (#{ce_f.object.event.play_exp})?"
              ce_f.input :cleaned, label: "Cleaned XP (#{ce_f.object.event.clean_exp})?"
            end
          end
        end


        f.inputs 'Deaths', header: "" do
          f.semantic_fields_for :deaths, allow_destroy: true do |d_f|
            d_f.inputs 'Death', header: "" do
              d_f.input :date, collection: f.object.events.pluck(:weekend)
              d_f.input :description
              d_f.input :physical
              d_f.input :roleplay
            end
          end
        end
      end

      tab 'Mechanics' do

        f.inputs 'Skills', header: "" do
          f.semantic_fields_for :character_skills do |cp_s|
            cp_s.inputs 'Skill', header: "" do
              cp_s.semantic_fields_for :skill, cp_s.object.skill, allow_destroy: true do |s_f|
                s_f.input :source, collection: Skill::SOURCES
                s_f.input :name
                s_f.input :cost
              end
            end
          end
        end

        f.inputs 'Perks', header: "" do
          f.semantic_fields_for :character_perks do |cp_f|
            cp_f.inputs 'Perk', header: "" do
              cp_f.semantic_fields_for :perk, cp_f.object.perk, allow_destroy: true do |p_f|
                p_f.input :source, collection: (Character::RACES|Character::CULTURES)
                p_f.input :name
                p_f.input :cost
              end
            end
          end
        end

      end

      tab 'Talents & Projects' do

        f.inputs 'Talents', header: "" do
          f.semantic_fields_for :talents, allow_destroy: true do |t_f|
            t_f.inputs "Talent", header: "" do
              t_f.input :spec
              t_f.input :group, collection: Talent::GROUPS
              t_f.input :name
              t_f.input :rank, input_html: { disabled: true }
              t_f.input :value
              t_f.input :investment_limit
            end
          end
        end

        f.inputs 'Project Contributions', header: "" do
          f.semantic_fields_for :project_contributions, allow_destroy: true do |pc_f|
            pc_f.inputs "Contribution", header: "" do
              pc_f.input :project
              pc_f.input :timeunits
              pc_f.input :talent, collection: f.object.talents.map { |t| [ "#{t.rank} - #{t.name}", t.id ] }
              pc_f.input :note
            end
          end
        end
      end
    end
    f.actions
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
