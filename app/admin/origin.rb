ActiveAdmin.register Origin do
  member_action :history do
    @origin = Origin.find(params[:id])
    @versions = @origin.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_origin_path(resource)
  end

  controller do
    def show
      @origin = Origin.includes(versions: :item).find(params[:id])
      @versions = @origin.versions
      @origin = @origin.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end