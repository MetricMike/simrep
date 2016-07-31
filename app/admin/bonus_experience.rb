ActiveAdmin.register BonusExperience do
  menu false
  includes :character

  index do
    selectable_column
    column :id do |be|
      link_to be.id, admin_bonus_experience_path(be)
    end
    column :character do |be|
      link_to be.character.display_name, admin_character_path(be.character)
    end
    column :reason
    column :amount
    column :date_awarded
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      input :character
      input :reason
      input :amount
      input :date_awarded, as: :date_picker
    end

    f.actions
  end
end
