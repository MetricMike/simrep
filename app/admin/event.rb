ActiveAdmin.register Event do

  controller do
    def scoped_collection
      super.includes :characters, :character_events
    end
  end

  csv_importable :columns => [:campaign, :weekend, :play_exp, :clean_exp]

  sidebar "Attending Characters", only: :show do
    table_for event.character_events.order(params[:order].to_s.gsub(/(.*)(_)(.*)/, '\1 \3')), sortable: true do
      column(:character, sortable: false) { |t| Character.find(t.character_id).name }
      column :paid
      column :cleaned
    end
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
