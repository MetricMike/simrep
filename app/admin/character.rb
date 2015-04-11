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
