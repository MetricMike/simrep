ActiveAdmin.register Perk do
  menu false
  member_action :history do
    @perk = Perk.find(params[:id])
    @versions = @perk.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_perk_path(resource)
  end

  controller do
    def show
      @perk = Perk.includes(versions: :item).find(params[:id])
      @versions = @perk.versions
      @perk = @perk.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end