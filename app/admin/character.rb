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

  form do |f|
    tabs do

      tab 'Demographics' do
        f.inputs 'Demographics' do
          f.inputs :user, :name, :costume, :costume_checked, :history_approval, :history_link, :unused_talents
          f.input :race, collection: Character::RACES
          f.input :culture, collection: Character::CULTURES
        end
      end

      tab 'Events' do
        f.inputs 'Events' do
          f.has_many :character_events, allow_destroy: true do |ce_f|
            ce_f.input :event, member_label: Proc.new { |e| "#{e.campaign} / #{e.weekend}" }
            ce_f.input :paid
            ce_f.input :cleaned
          end
        end
      end

      tab 'Skills' do
        f.inputs 'Skills' do
          f.has_many :character_skills, allow_destroy: true do |cs_f|
            cs_f.inputs 'Skill' do |s|
              s.input :source, collection: Skill::SOURCES
              s.input :name
              s.input :cost
            end
          end
        end
      end

      tab 'Perks' do
        f.inputs 'Perks' do
          f.has_many :character_perks, allow_destroy: true do |cp_f|
            cp_f.inputs
          end
        end
      end

      tab 'Talents' do
        f.inputs 'Talents' do
          f.has_many :talents, allow_destroy: true do |t_f|
            t_f.inputs
          end
        end
      end

      tab 'Project Contributions' do
        f.inputs 'Project Contributions' do
          f.has_many :project_contributions, allow_destroy: true do |pc_f|
            pc_f.inputs
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
