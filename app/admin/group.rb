ActiveAdmin.register Group do
  config.filters = false

  menu false
  member_action :history do
    @group = Group.find(params[:id])
    @versions = @group.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_group_path(resource)
  end

  controller do
    def show
      @group = Group.includes(versions: :item).find(params[:id])
      @versions = @group.versions
      @group = @group.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end