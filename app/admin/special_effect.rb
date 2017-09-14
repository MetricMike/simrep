ActiveAdmin.register SpecialEffect do
  menu false

  form do |f|
    f.inputs do
      input :character
      input :description
      input :expiration, as: :date_time_picker, datepicker_options: { step: 15 }
    end

    f.actions
  end
end
