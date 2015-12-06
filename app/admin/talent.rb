ActiveAdmin.register Talent do
  member_action :history do
    @talent = Talent.find(params[:id])
    @versions = @talent.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_talent_path(resource)
  end

  controller do
    def show
      @talent = Talent.includes(versions: :item).find(params[:id])
      @versions = @talent.versions
      @talent = @talent.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end