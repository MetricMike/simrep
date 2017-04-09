ActiveAdmin.register Event do
  menu false

  controller do
    def scoped_collection
      super.includes :characters, :character_events
    end
  end

  member_action :award_attendance do
    characters = CharacterEvent.where(event: resource)
    characters.map(&:give_attendance_awards)
    redirect_to resource_path, notice: "All attending players awarded for attendance."
  end

  action_item :award_attendance, only: :show do
    link_to "Award Attendance", award_attendance_admin_event_path(resource)
  end

  filter :campaign
  filter :play_exp
  filter :clean_exp
  filter :weekend

  show do
    attributes_table do
      row :id
      row :campaign
      row :weekend
      row :play_exp
      row :clean_exp
      row :created_at
      row :updated_At
    end
    panel "Attending Characters", only: :show do
      para "#{resource.characters.count} Attended"
      para "#{resource.paying_characters.count} Paid"
      para "#{resource.new_characters.count} New"
      table_for event.character_events.includes(character: :user).order(params[:order].to_s.gsub(/(.*)(_)(.*)/, '\1 \3')).order('characters.name ASC'), sortable: true do
        column(:player) { |ce| link_to ce.character.user.name, admin_user_path(ce.character.user_id) }
        column(:character) { |ce| link_to ce.character.name, admin_character_path(ce.character_id) }
        column :paid
        column :cleaned
        column :awarded
      end
    end
  end
end
