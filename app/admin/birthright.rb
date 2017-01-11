ActiveAdmin.register Birthright do
  menu false
  member_action :history do
    @birthright = Birthright.find(params[:id])
    @versions = @birthright.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_birthright_path(resource)
  end

  controller do
    def show
      @birthright = Birthright.includes(versions: :item).find(params[:id])
      @versions = @birthright.versions
      @birthright = @birthright.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end