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
      tab 'Details' do
        f.inputs 'Details' do
          f.inputs :user, :name, :costume, :costume_checked, :history_approval, :history_link, :unused_talents
          f.input :race, collection: Character::RACES
          f.input :culture, collection: Character::CULTURES
        end
      end

      tab 'Events' do
        f.inputs 'Events' do
          f.has_many :character_events, allow_destroy: true do |ev_f|
            ev_f.input :event, member_label: Proc.new { |e| "#{e.campaign} / #{e.weekend}" }
            ev_f.input :paid
            ev_f.input :cleaned
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
