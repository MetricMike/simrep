ActiveAdmin.register ProjectContribution do
  menu false
  member_action :history do
    @project_contribution = ProjectContribution.find(params[:id])
    @versions = @project_contribution.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_project_contribution_path(resource)
  end

  controller do
    def show
      @project_contribution = ProjectContribution.includes(versions: :item).find(params[:id])
      @versions = @project_contribution.versions
      @project_contribution = @project_contribution.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end