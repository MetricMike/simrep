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

  member_action :history do
    @death = Death.find(params[:id])
    @versions = @death.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_death_path(resource)
  end

  controller do
    def show
      @death = Death.includes(versions: :item).find(params[:id])
      @versions = @death.versions
      @death = @death.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end