ActiveAdmin.register Background do
  menu false

  member_action :history do
    @background = Background.find(params[:id])
    @versions = @background.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_background_path(resource)
  end

  controller do
    def show
      @background = Background.includes(versions: :item).find(params[:id])
      @versions = @background.versions
      @background = @background.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end