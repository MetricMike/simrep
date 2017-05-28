ActiveAdmin.register Death do
  menu false

  index do
    selectable_column
    column :id do |d|
      link_to d.id, admin_death_path(d)
    end
    column :character do |d|
      if d.character.present?
        link_to d.character.name, admin_character_path(d.character)
      else
        "N/A"
      end
    end
    column :description
    column :physical
    column :roleplay
    column :weekend
    column :countable
    actions
  end
end
