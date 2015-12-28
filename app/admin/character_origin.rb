ActiveAdmin.register CharacterOrigin do
  menu false
  member_action :history do
    @character_origin = CharacterOrigin.find(params[:id])
    @versions = @character_origin.versions
    render "admin/shared/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_character_origin_path(resource)
  end

  controller do
    def show
      @character_origin = CharacterOrigin.includes(versions: :item).find(params[:id])
      @versions = @character_origin.versions
      @character_origin = @character_origin.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  sidebar :versionate, :partial => "admin/shared/version", :only => :show
end