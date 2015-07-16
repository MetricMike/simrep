ActiveAdmin.register NpcShift do

  begin
    filter :character_event
    filter :opening
    filter :closing
    filter :verified
    filter :dirty
  rescue
    p "msg"
  end

  form do |f|
    f.inputs do
      input :character_event, as: :select
      input :opening, as: :date_time_picker, datepicker_options: { step: 15 }
      input :closing, as: :date_time_picker, datepicker_options: { step: 15 }
      input :verified
      input :dirty
    end

    f.actions
  end

  batch_action :verify_shift do |ids|
    batch_action_collection.find(ids).each do |shift|
      shift.verify
    end
    redirect_to collection_path, notice: [ids].to_s
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