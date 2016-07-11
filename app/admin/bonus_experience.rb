ActiveAdmin.register BonusExperience do
  menu false
  includes :character

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
