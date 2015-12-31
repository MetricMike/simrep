ActiveAdmin.register Death do
  menu false

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