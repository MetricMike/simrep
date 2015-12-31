ActiveAdmin.register Project do
  menu false
  member_action :history do
    @project = Project.find(params[:id])
    @versions = @project.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_project_path(resource)
  end

  controller do
    def show
      @project = Project.includes(versions: :item).find(params[:id])
      @versions = @project.versions
      @project = @project.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end